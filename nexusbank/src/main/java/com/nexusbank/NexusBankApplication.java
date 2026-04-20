package com.nexusbank;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@ConfigurationPropertiesScan("com.nexusbank.config")
@EnableJpaRepositories(basePackages = "com.nexusbank.repository")
@EnableAsync
public class NexusBankApplication {

    public static void main(String[] args) {
        SpringApplication.run(NexusBankApplication.class, args);
    }
}
