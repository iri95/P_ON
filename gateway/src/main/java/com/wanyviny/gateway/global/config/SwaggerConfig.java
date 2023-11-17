package com.wanyviny.gateway.global.config;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.web.filter.ForwardedHeaderFilter;

@Configuration
public class SwaggerConfig {

    @Bean
    public RouteLocator routeLocator(RouteLocatorBuilder builder) {
        return builder
                .routes()
                .route(r -> r.path("/v3/user/api-docs").and().method(HttpMethod.GET).uri("lb://USER-SERVICE"))
                .route(r -> r.path("/v3/promise/api-docs").and().method(HttpMethod.GET).uri("lb://PROMISE-SERVICE"))
                .route(r -> r.path("/v3/vote/api-docs").and().method(HttpMethod.GET).uri("lb://VOTE-SERVICE"))
                .route(r -> r.path("/v3/calendar/api-docs").and().method(HttpMethod.GET).uri("lb://CALENDAR-SERVICE"))
                .route(r -> r.path("/v3/alarm/api-docs").and().method(HttpMethod.GET).uri("lb://ALARM-SERVICE"))
                .build();
    }

    @Bean
    ForwardedHeaderFilter forwardedHeaderFilter() {
        return new ForwardedHeaderFilter();
    }
}
