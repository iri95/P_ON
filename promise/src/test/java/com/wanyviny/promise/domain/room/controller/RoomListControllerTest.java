//package com.wanyviny.promise.domain.room.controller;
//
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
//
//import com.epages.restdocs.apispec.MockMvcRestDocumentationWrapper;
//import com.epages.restdocs.apispec.ResourceSnippetParameters;
//import com.wanyviny.promise.RestDocsSupport;
//import com.wanyviny.promise.domain.common.BasicResponse;
//import com.wanyviny.promise.domain.room.service.RoomListService;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
//import org.springframework.boot.test.mock.mockito.MockBean;
//import org.springframework.http.MediaType;
//import org.springframework.http.ResponseEntity;
//import org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders;
//
//@WebMvcTest(RoomListControllerTest.class)
//public class RoomListControllerTest extends RestDocsSupport {
//
//    @MockBean
//    RoomListService roomListService;
//
//    @Test
//    @DisplayName("약속방 목록 생성 테스트")
//    void postTest() throws Exception {
//        ResponseEntity<BasicResponse> response = createResponse();
//
//        mockMvc.perform(
//                        RestDocumentationRequestBuilders.post("https://p-on.site/api/promise/room-list/999999")
//                                .contentType(MediaType.APPLICATION_JSON)
//                )
//                .andExpect(status().isOk())
//                .andDo(MockMvcRestDocumentationWrapper.document("room-post",
//                        ResourceSnippetParameters.builder()
//                                .tag("약속방 목록")
//                                .summary("약속방 목록 생성")));
//    }
//}
