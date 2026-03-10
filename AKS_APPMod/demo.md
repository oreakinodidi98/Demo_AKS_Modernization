# Spring PetClinic Demo - AKS Modernization

A step-by-step guide to running the Spring PetClinic application locally before deploying to Azure Kubernetes Service.

---

## Prerequisites

Before starting, ensure the following are configured:

1. **Docker Desktop** - Switch to Linux containers:
   ```powershell
   & "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchLinuxEngine
   ```

2. **Java 17+** installed and available in PATH

3. **Native PostgreSQL stopped** (if installed):
   ```powershell
   Stop-Service -Name "postgresql*"
   ```

---

## Running PetClinic Locally

### Option A: Quick Start with H2 (In-Memory Database)

Best for quick testing - no database setup required.

```powershell
cd spring-petclinic
.\mvnw spring-boot:run
```

Access the app at: **http://localhost:8080**

---

### Option B: With PostgreSQL (Docker)

Use this to match the production environment.

#### Step 1: Start PostgreSQL Container

```powershell
docker run -d --name petclinic-postgres `
  -e POSTGRES_USER=petclinic `
  -e POSTGRES_PASSWORD=petclinic `
  -e POSTGRES_DB=petclinic `
  -p 5432:5432 `
  postgres:15
```

#### Step 2: Wait for Database to Initialize

```powershell
Start-Sleep -Seconds 10
```

#### Step 3: Run the Application

```powershell
cd spring-petclinic
.\mvnw spring-boot:run "-Dspring-boot.run.profiles=postgres"
```

Access the app at: **http://localhost:8080**

#### Step 4: Explore the Application

- Once running try features like find owners, View owner details , Edit pet information or review Veterinarians

---

## Troubleshooting

### Port 8080 Already in Use

1. Find the process using the port:
   ```powershell
   netstat -ano | findstr :8080
   ```

2. Get process details (replace `<PID>` with the ID from step 1):
   ```powershell
   Get-Process -Id <PID>
   ```

3. Stop the process:
   ```powershell
   Stop-Process -Id <PID> -Force
   ```

**Alternative:** Run PetClinic on a different port:
```powershell
.\mvnw spring-boot:run "-Dspring-boot.run.profiles=postgres" "-Dserver.port=8081"
```

---

### PostgreSQL Connection Issues

**Reset the Docker container:**

```powershell
docker stop petclinic-postgres
docker rm petclinic-postgres
```

Then restart from [Step 1](#step-1-start-postgresql-container).

**Check if native PostgreSQL is running:**

```powershell
netstat -ano | findstr :5432
```

If occupied, stop the native service:
```powershell
Stop-Service -Name "postgresql*"
```

---

## Archive (Legacy Commands)

<details>
<summary>Click to expand alternative configurations</summary>

### Manual Database Configuration

```powershell
.\mvnw clean compile; .\mvnw spring-boot:run `
  "-Dspring-boot.run.arguments=--spring.messages.basename=messages/messages --spring.datasource.url=jdbc:postgresql://localhost/petclinic --spring.sql.init.mode=always --spring.sql.init.schema-locations=classpath:db/postgres/schema.sql --spring.sql.init.data-locations=classpath:db/postgres/data.sql --spring.jpa.hibernate.ddl-auto=none"
```

### Simplified PostgreSQL Profile

```powershell
.\mvnw spring-boot:run "-Dspring-boot.run.arguments=--spring.datasource.url=jdbc:postgresql://localhost/petclinic --spring.sql.init.mode=always --spring.profiles.active=postgres"
```

</details>