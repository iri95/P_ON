package com.wanyviny.promise.test.controller;

import static org.springframework.restdocs.operation.preprocess.Preprocessors.preprocessRequest;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.preprocessResponse;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.prettyPrint;
import static org.springframework.restdocs.payload.PayloadDocumentation.fieldWithPath;
import static org.springframework.restdocs.payload.PayloadDocumentation.requestFields;
import static org.springframework.restdocs.payload.PayloadDocumentation.responseFields;
import static org.springframework.restdocs.request.RequestDocumentation.parameterWithName;
import static org.springframework.restdocs.request.RequestDocumentation.pathParameters;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.epages.restdocs.apispec.MockMvcRestDocumentationWrapper;
import com.epages.restdocs.apispec.ResourceSnippetParameters;
import com.epages.restdocs.apispec.Schema;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.promise.test.dto.MainRequest;
import com.wanyviny.promise.test.dto.MainRequest.Patch;
import com.wanyviny.promise.test.dto.MainRequest.Post;
import com.wanyviny.promise.test.dto.MainRequest.Put;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders;
import org.springframework.restdocs.payload.JsonFieldType;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(MainController.class)
@AutoConfigureMockMvc
@AutoConfigureRestDocs
class MainControllerTest {

    @Autowired
    private MockMvc mockMvc;

    private final ObjectMapper mapper = new ObjectMapper();

    @Test
    @DisplayName("Get 테스트")
    void getTest() throws Exception {
        mockMvc.perform(
                        RestDocumentationRequestBuilders.get("/api/promise/test")
                )
                .andExpect(status().isOk())
                .andDo(MockMvcRestDocumentationWrapper.document("test-get",
                        ResourceSnippetParameters.builder()
                                .tag("테스트")
                                .summary("Get 테스트")
                                .description("Get 테스트")
                                .responseSchema(Schema.schema("MainResponse.Get"))
                        ,
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        responseFields(
                                fieldWithPath("message").type(JsonFieldType.STRING).description("메세지")
                        )
                ));

    }

    @Test
    @DisplayName("Post 테스트")
    void postTest() throws Exception {
        MainRequest.Post request = new Post("post request");
        mockMvc.perform(
                        RestDocumentationRequestBuilders.post("/api/promise/test")
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(mapper.writeValueAsString(request))
                )
                .andExpect(status().isCreated())
                .andDo(MockMvcRestDocumentationWrapper.document("test-post",
                        ResourceSnippetParameters.builder()
                                .tag("테스트")
                                .summary("Post 테스트")
                                .description("Post 테스트")
                                .requestSchema(Schema.schema("MainRequest.Post"))
                                .responseSchema(Schema.schema("MainResponse.Post"))
                        ,
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        requestFields(
                                fieldWithPath("message").type(JsonFieldType.STRING).description("요청 메시지")
                        ),
                        responseFields(
                                fieldWithPath("id").type(JsonFieldType.NUMBER).description("생성 ID")
                        )));
    }

    @Test
    @DisplayName("Put 테스트")
    void putTest() throws Exception {
        Long requestId = 1L;
        MainRequest.Put requestBody = new Put("put request");

        mockMvc.perform(
                        RestDocumentationRequestBuilders.put("/api/promise/test/{id}", requestId)
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(mapper.writeValueAsString(requestBody))
                )
                .andExpect(status().isOk())
                .andDo(MockMvcRestDocumentationWrapper.document("test-put",
                        ResourceSnippetParameters.builder()
                                .tag("테스트")
                                .summary("Put 테스트")
                                .description("Put 테스트")
                                .requestSchema(Schema.schema("MainRequest.Put"))
                                .responseSchema(Schema.schema("MainResponse.Put"))
                        ,
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        pathParameters(
                                parameterWithName("id").description("수정 ID")
                        ),
                        requestFields(
                                fieldWithPath("message").type(JsonFieldType.STRING).description("요청 메세지")
                        ),
                        responseFields(
                                fieldWithPath("message").type(JsonFieldType.STRING).description("응답 메세지")
                        )
                ));
    }

    @Test
    @DisplayName("Patch 테스트")
    void patchTest() throws Exception {
        Long requestId = 1L;
        MainRequest.Patch requestBody = new Patch("patch request");

        mockMvc.perform(
                        RestDocumentationRequestBuilders.patch("/api/promise/test/{id}", requestId)
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(mapper.writeValueAsString(requestBody))
                )
                .andExpect(status().isOk())
                .andDo(MockMvcRestDocumentationWrapper.document("test-patch",
                        ResourceSnippetParameters.builder()
                                .tag("테스트")
                                .summary("Patch 테스트")
                                .description("Patch 테스트")
                                .requestSchema(Schema.schema("MainRequest.Patch"))
                                .responseSchema(Schema.schema("MainResponse.Post"))
                        ,
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        pathParameters(
                                parameterWithName("id").description("수정 ID")
                        ),
                        requestFields(
                                fieldWithPath("message").type(JsonFieldType.STRING).description("요청 메세지")
                        ),
                        responseFields(
                                fieldWithPath("message").type(JsonFieldType.STRING).description("응답 메세지")
                        )
                ));
    }

    @Test
    @DisplayName("Delete 테스트")
    void deleteTest() throws Exception {
        Long request = 1L;

        mockMvc.perform(
                        RestDocumentationRequestBuilders.delete("/api/promise/test/{id}", request)
                )
                .andExpect(status().isNoContent())
                .andDo(MockMvcRestDocumentationWrapper.document("test-delete",
                        ResourceSnippetParameters.builder()
                                .tag("테스트")
                                .summary("Delete 테스트")
                                .description("Delete 테스트")
                        ,
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        pathParameters(
                                parameterWithName("id").description("삭제 ID")
                        )
                ));
    }
}
