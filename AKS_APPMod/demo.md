# Demo

## Verify PetClinic Locally

- After Setup enter spring-petclinic ddirectory
- Run ```mvn clean compile; mvn spring-boot:run "-Dspring-boot.run.arguments=--spring.messages.basename=messages/messages --spring.datasource.url=jdbc:postgresql://localhost/petclinic --spring.sql.init.mode=always --spring.sql.init.schema-locations=classpath:db/postgres/schema.sql --spring.sql.init.data-locations=classpath:db/postgres/data.sql --spring.jpa.hibernate.ddl-auto=none"```

``` pws

```