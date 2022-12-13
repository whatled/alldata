
package com.platform.modules.mnt.service.mapstruct;

import com.platform.base.BaseMapper;
import com.platform.modules.mnt.domain.App;
import com.platform.modules.mnt.service.dto.AppDto;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

/**
* @author zhanghouying
* @date 2022-10-27
*/
@Mapper(componentModel = "spring",uses = {},unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface AppMapper extends BaseMapper<AppDto, App> {

}
