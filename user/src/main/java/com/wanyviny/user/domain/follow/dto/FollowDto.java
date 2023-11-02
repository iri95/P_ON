package com.wanyviny.user.domain.follow.dto;

import com.wanyviny.user.domain.user.dto.UserDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class FollowDto implements Comparable<FollowDto>{
    private boolean followBack;
    private UserDto follow;

    @Override
    public int compareTo(FollowDto o) {
        if(this.followBack && o.followBack)return 0;
        else if(this.followBack) return -1;
        else return 1;
    }
}
