# sonar-analyse-script

Sonar script to analyse java 8 project with maven

`start.sh -r` Run sonar in docker (don't forget to configure projet)
`start.sh -a`Analyse the project (don't forget to configure variable in the beginning of script)

## Config pom.xml 

```xml
<plugin>
  <groupId>org.sonarsource.scanner.maven</groupId>
  <artifactId>sonar-maven-plugin</artifactId>
  <version>${sonar-maven-plugin.version}</version>
</plugin>
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <version>${jacoco-maven-plugin.version}</version>
  <executions>
    <execution>
    <id>prepare-agent</id>
    <goals>
      <goal>prepare-agent</goal>
    </goals>
    </execution>
    <execution>
    <id>report</id>
    <goals>
      <goal>report</goal>
    </goals>
    </execution>
  </executions>
</plugin>
```
