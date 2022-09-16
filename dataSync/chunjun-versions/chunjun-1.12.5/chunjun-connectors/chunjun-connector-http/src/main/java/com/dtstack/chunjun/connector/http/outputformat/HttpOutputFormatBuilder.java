/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.dtstack.chunjun.connector.http.outputformat;

import com.dtstack.chunjun.connector.http.common.HttpWriterConfig;
import com.dtstack.chunjun.sink.format.BaseRichOutputFormatBuilder;

/**
 * @author : tiezhu
 * @date : 2020/3/12
 */
public class HttpOutputFormatBuilder extends BaseRichOutputFormatBuilder {

    private HttpOutputFormat format;

    public HttpOutputFormatBuilder() {
        super.format = format = new HttpOutputFormat();
    }

    public void setConfig(HttpWriterConfig httpWriterConfig) {
        super.setConfig(httpWriterConfig);
        this.format.httpWriterConfig = httpWriterConfig;
    }

    @Override
    protected void checkFormat() {
        if (format.httpWriterConfig.getUrl().isEmpty()) {
            throw new IllegalArgumentException("url is must");
        }
        if (format.httpWriterConfig.getMethod().isEmpty()) {
            throw new IllegalArgumentException("method is must");
        }
    }
}
