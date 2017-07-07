package org.apereo.cas.config.pm;

import org.apereo.cas.CipherExecutor;
import org.apereo.cas.configuration.CasConfigurationProperties;
import org.apereo.cas.configuration.support.Beans;
import org.apereo.cas.pm.PasswordManagementService;
import org.apereo.cas.pm.jdbc.JdbcPasswordManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.Serializable;

/**
 * This is {@link JdbcPasswordManagementConfiguration}.
 *
 * @author Misagh Moayyed
 * @since 5.2.0
 */
@Configuration("jdbcPasswordManagementConfiguration")
@EnableConfigurationProperties(CasConfigurationProperties.class)
public class JdbcPasswordManagementConfiguration {
    @Autowired
    private CasConfigurationProperties casProperties;

    @Autowired
    @Qualifier("passwordManagementCipherExecutor")
    private CipherExecutor<Serializable, String> passwordManagementCipherExecutor;
    
    @RefreshScope
    @Bean
    public PasswordManagementService passwordChangeService() {
        return new JdbcPasswordManagementService(passwordManagementCipherExecutor,
                casProperties.getServer().getPrefix(),
                casProperties.getAuthn().getPm(),
                Beans.newDataSource(casProperties.getAuthn().getPm().getJdbc()));
    }
}
