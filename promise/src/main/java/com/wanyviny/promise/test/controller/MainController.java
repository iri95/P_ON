package com.wanyviny.promise.test.controller;

import com.wanyviny.promise.test.dto.MainRequest;
import com.wanyviny.promise.test.dto.MainResponse;
import com.wanyviny.promise.test.dto.MainResponse.Get;
import com.wanyviny.promise.test.dto.MainResponse.Post;
import java.net.URI;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

@RestController
@RequestMapping("/api/promise/test")
public class MainController {

    @GetMapping
    public ResponseEntity<Get> get() {
        return ResponseEntity.ok(
                new MainResponse.Get("get test success")
        );
    }

    @PostMapping
    public ResponseEntity<MainResponse.Post> post(@RequestBody MainRequest.Post request) {
        MainResponse.Post response = new Post(1L);
        final URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("{id}")
                .buildAndExpand(response.id())
                .toUri();
        return ResponseEntity.created(location)
                .body(response);
    }

    @PutMapping("/{id}")
    public ResponseEntity<MainResponse.Put> put(@PathVariable Long id,
            @RequestBody MainRequest.Put request) {
        return ResponseEntity.ok(
                new MainResponse.Put("put test success")
        );
    }

    @PatchMapping("/{id}")
    public ResponseEntity<MainResponse.Patch> patch(@PathVariable Long id,
            @RequestBody MainRequest.Patch request) {
        return ResponseEntity.ok(
                new MainResponse.Patch("patch test success")
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return ResponseEntity.noContent().build();
    }
}
