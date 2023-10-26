package com.wanyviny.promise.test.dto;

public class MainResponse {

    public record Get(String message) {

    }

    public record Post(Long id) {

    }

    public record Put(String message) {

    }

    public record Patch(String message) {

    }
}
