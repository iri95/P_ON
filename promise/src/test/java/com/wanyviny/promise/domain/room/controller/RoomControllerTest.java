package com.wanyviny.promise.domain.room.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.preprocessRequest;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.preprocessResponse;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.prettyPrint;
import static org.springframework.restdocs.payload.PayloadDocumentation.fieldWithPath;
import static org.springframework.restdocs.payload.PayloadDocumentation.requestFields;
import static org.springframework.restdocs.payload.PayloadDocumentation.responseFields;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.epages.restdocs.apispec.MockMvcRestDocumentationWrapper;
import com.epages.restdocs.apispec.ResourceSnippetParameters;
import com.epages.restdocs.apispec.Schema;
import com.wanyviny.promise.RestDocsSupport;
import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.room.dto.RoomRequest;
import com.wanyviny.promise.domain.room.dto.RoomResponse;
import com.wanyviny.promise.domain.room.service.RoomListService;
import com.wanyviny.promise.domain.room.service.RoomService;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders;
import org.springframework.restdocs.payload.JsonFieldType;
//
@WebMvcTest(RoomController.class)
public class RoomControllerTest extends RestDocsSupport {

    @MockBean
    RoomService roomService;

    @MockBean
    RoomListService roomListService;

    @Test
    @DisplayName("약속방 생성 테스트")
    void postTest() throws Exception {
        RoomRequest.CreateDto request = createRequest();
        RoomResponse.CreateDto dto = createDto();

        given(roomService.createRoom(any()))
                .willReturn(dto);

        mockMvc.perform(
                RestDocumentationRequestBuilders.post("/api/promise/room")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                )
                .andExpect(status().isOk())
                .andDo(MockMvcRestDocumentationWrapper.document("room-post",
                        ResourceSnippetParameters.builder()
                                .tag("약속방")
                                .summary("약속방 생성")
                                .requestSchema(Schema.schema("약속방 생성 Request"))
//                                .responseSchema(Schema.schema("RoomResponse.CreateDto")
//                                ),
//                        preprocessRequest(prettyPrint()),
//                        preprocessResponse(prettyPrint()),
//                        requestFields(
//                                fieldWithPath("users").type(JsonFieldType.ARRAY).description("유저 목록"),
//                                fieldWithPath("users[].userId").type(JsonFieldType.STRING).description("유저 아이디"),
//                                fieldWithPath("users[].nickname").type(JsonFieldType.STRING).description("유저 닉네임"),
//                                fieldWithPath("promiseTitle").type(JsonFieldType.STRING).description("약속방 제목"),
//                                fieldWithPath("promiseDate").type(JsonFieldType.STRING).description("약속 날짜"),
//                                fieldWithPath("promiseTime").type(JsonFieldType.STRING).description("약속 시간"),
//                                fieldWithPath("promiseLocation").type(JsonFieldType.STRING).description("약속 장소")
//                        ),
//                        responseFields(
//                                fieldWithPath("httpStatus").type(JsonFieldType.STRING).description("HTTP 상태"),
//                                fieldWithPath("code").type(JsonFieldType.NUMBER).description("HTTP 상태 코드"),
//                                fieldWithPath("message").type(JsonFieldType.STRING).description("결과 메세지"),
//                                fieldWithPath("count").type(JsonFieldType.NUMBER).description("결과 수"),
//                                fieldWithPath("result[].id").type(JsonFieldType.STRING).description("약송방 ID"),
//                                fieldWithPath("result[].users").type(JsonFieldType.ARRAY).description("유저 목록"),
//                                fieldWithPath("result[].users[].userId").type(JsonFieldType.STRING).description("유저 목록"),
//                                fieldWithPath("result[].users[].nickname").type(JsonFieldType.STRING).description("유저 목록"),
//                                fieldWithPath("result[].promiseTitle").type(JsonFieldType.STRING).description("약속방 제목"),
//                                fieldWithPath("result[].isDefaultTitle").type(JsonFieldType.BOOLEAN).description("기본 제목"),
//                                fieldWithPath("result[].promiseDate").type(JsonFieldType.STRING).description("약속 날짜"),
//                                fieldWithPath("result[].promiseTime").type(JsonFieldType.STRING).description("약속 시간"),
//                                fieldWithPath("result[].promiseLocation").type(JsonFieldType.STRING).description("약속 장소"),
//                                fieldWithPath("result[].chats").type(JsonFieldType.ARRAY).description("채팅 리스트")
//                        )));
                ));
    }

    private RoomRequest.CreateDto createRequest() {
        
        List<Map<String, String>> users = new ArrayList<>();
        Map<String, String> user = new HashMap<>();

        user.put("userId", "1");
        user.put("nickname", "김태환");
        users.add(user);

        return RoomRequest.CreateDto
                .builder()
                .users(users)
                .promiseTitle("미정")
                .build();
    }

    private RoomResponse.CreateDto createDto() {

        List<Map<String, String>> users = new ArrayList<>();
        Map<String, String> user = new HashMap<>();

        user.put("userId", "1");
        user.put("nickname", "김태환");
        users.add(user);

        return RoomResponse.CreateDto
                .builder()
                .id("1234")
                .users(users)
                .promiseTitle("미정")
                .isDefaultTitle(false)
                .promiseDate("미정")
                .promiseTime("미정")
                .promiseLocation("미정")
                .chats(new ArrayList<>())
                .build();
    }
}
