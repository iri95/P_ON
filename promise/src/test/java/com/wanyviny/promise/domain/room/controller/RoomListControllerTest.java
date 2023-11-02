package com.wanyviny.promise.domain.room.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.preprocessRequest;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.preprocessResponse;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.prettyPrint;
import static org.springframework.restdocs.payload.PayloadDocumentation.fieldWithPath;
import static org.springframework.restdocs.payload.PayloadDocumentation.responseFields;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.epages.restdocs.apispec.MockMvcRestDocumentationWrapper;
import com.epages.restdocs.apispec.ResourceSnippetParameters;
import com.epages.restdocs.apispec.Schema;
import com.wanyviny.promise.RestDocsSupport;
import com.wanyviny.promise.domain.room.dto.RoomListResponse;
import com.wanyviny.promise.domain.room.service.RoomListService;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders;
import org.springframework.restdocs.payload.JsonFieldType;

@WebMvcTest(RoomListController.class)
public class RoomListControllerTest extends RestDocsSupport {

    @MockBean
    RoomListService roomListService;

    @Test
    @DisplayName("약속방 목록 생성 테스트")
    void postTest() throws Exception {

        mockMvc.perform(
                        RestDocumentationRequestBuilders.post("/api/promise/room-list/{userId}", "1")
                                .contentType(MediaType.APPLICATION_JSON)
                )
                .andExpect(status().isOk())
                .andDo(MockMvcRestDocumentationWrapper.document("room-list-post",
                        ResourceSnippetParameters.builder()
                                .tag("약속방 목록")
                                .summary("약속방 목록 생성")
                                .responseSchema(Schema.schema("약속방 목록 생성 Response")
                                ),
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        responseFields(
                                fieldWithPath("httpStatus").type(JsonFieldType.STRING).description("HTTP 상태"),
                                fieldWithPath("code").type(JsonFieldType.NUMBER).description("HTTP 상태 코드"),
                                fieldWithPath("message").type(JsonFieldType.STRING).description("결과 메세지")
                        )));
    }

    @Test
    @DisplayName("약속방 목록 조회 테스트")
    void getTest() throws Exception {

        RoomListResponse.FindDto dto = findDto();

        given(roomListService.findRoomList(any()))
                .willReturn(dto);

        mockMvc.perform(
                        RestDocumentationRequestBuilders. get("/api/promise/room-list/{userId}", "1")
                                .contentType(MediaType.APPLICATION_JSON)
                )
                .andExpect(status().isOk())
                .andDo(print())
                .andDo(MockMvcRestDocumentationWrapper.document("room-list-get",
                        ResourceSnippetParameters.builder()
                                .tag("약속방 목록")
                                .summary("약속방 목록 조회")
                                .responseSchema(Schema.schema("약속방 목록 조회 Response")
                                ),
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        responseFields(
                                fieldWithPath("httpStatus").type(JsonFieldType.STRING).description("HTTP 상태"),
                                fieldWithPath("code").type(JsonFieldType.NUMBER).description("HTTP 상태 코드"),
                                fieldWithPath("message").type(JsonFieldType.STRING).description("결과 메세지"),
                                fieldWithPath("count").type(JsonFieldType.NUMBER).description("결과 메세지"),
                                fieldWithPath("result").type(JsonFieldType.ARRAY).description("결과"),
                                fieldWithPath("result[].id").type(JsonFieldType.STRING).description("약속방 목록 ID"),
                                fieldWithPath("result[].rooms").type(JsonFieldType.ARRAY).description("약속방 목록"),
                                fieldWithPath("result[].rooms[].roomId").type(JsonFieldType.STRING).description("약속방 ID"),
                                fieldWithPath("result[].rooms[].promiseTitle").type(JsonFieldType.STRING).description("약속방 제목"),
                                fieldWithPath("result[].rooms[].promiseDate").type(JsonFieldType.STRING).description("약속방 날짜"),
                                fieldWithPath("result[].rooms[].promiseTime").type(JsonFieldType.STRING).description("약속방 시간"),
                                fieldWithPath("result[].rooms[].promiseLocation").type(JsonFieldType.STRING).description("약속방 장소"),
                                fieldWithPath("result[].rooms[].unread").type(JsonFieldType.STRING).description("읽음 여부")
                        )));
    }

    private RoomListResponse.FindDto findDto() {

        List<Map<String, String>> rooms = new ArrayList<>();
        Map<String, String> room = new HashMap<>();

        room.put("roomId", "6542f50e0a201e4b869721ed");
        room.put("promiseTitle", "미정");
        room.put("promiseDate", "미정");
        room.put("promiseTime", "미정");
        room.put("promiseLocation", "미정");
        room.put("unread", "false");
        rooms.add(room);

        return RoomListResponse.FindDto
                .builder()
                .id("1")
                .rooms(rooms)
                .build();
    }
}
