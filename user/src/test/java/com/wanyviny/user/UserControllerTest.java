package com.wanyviny.user;

import com.wanyviny.user.domain.user.controller.UserController;
import org.junit.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.restdocs.RestDocumentationExtension;

import static org.mockito.BDDMockito.given;
import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.payload.PayloadDocumentation.*;
import static org.springframework.restdocs.request.RequestDocumentation.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
@ExtendWith({RestDocumentationExtension.class})
@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureRestDocs
public class UserControllerTest {

    @MockBean
    private UserController userController;

    @Test
    @DisplayName("테스트 조회 Test")
    void findHomeByUserIdTest() throws Exception {
        // given


        // mockMvc perform


        // result

    }
}
