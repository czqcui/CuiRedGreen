# 第一阶段：使用Maven构建JAR（匹配Java 17版本）
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /build

# 复制项目文件（利用Docker缓存层优化）
COPY pom.xml .
COPY src ./src

# 构建可执行JAR（跳过测试）
RUN mvn clean package -DskipTests

# 第二阶段：创建轻量级运行环境
FROM registry.cn-hangzhou.aliyuncs.com/library/eclipse-temurin:17-jre
WORKDIR /app

# 从构建阶段复制生成的JAR文件（使用Spring Boot默认命名）
COPY --from=builder /build/target/CuiRedGreen-*.jar /app/app.jar

# 设置时区（可选）
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 暴露Spring Boot默认端口
EXPOSE 8080

# 启动应用（使用非root用户增强安全性）
RUN addgroup --system appuser && adduser --system --no-create-home --ingroup appuser appuser
USER appuser

ENTRYPOINT ["java", "-jar", "app.jar"]
