# 第一阶段：使用Maven构建JAR
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /build

COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# 第二阶段：使用标准 JRE 镜像（包含 shell）
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

COPY --from=builder /build/target/CuiRedGreen-*.jar /app/app.jar

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 使用非root用户
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
