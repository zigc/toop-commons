/**
 * Copyright (C) 2018 toop.eu
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package eu.toop.commons.jaxb;

import javax.annotation.Nonnull;

import com.helger.jaxb.builder.JAXBWriterBuilder;

import eu.toop.commons.dataexchange.TDETOOPDataRequestType;
import eu.toop.commons.dataexchange.TDETOOPDataResponseType;

public class ToopWriter<JAXBTYPE> extends JAXBWriterBuilder<JAXBTYPE, ToopWriter<JAXBTYPE>> {
  /**
   * Constructor with an arbitrary document type.
   *
   * @param aDocType
   *          Document type to be used. May not be <code>null</code>.
   */
  public ToopWriter (@Nonnull final EToopXMLDocumentType aDocType) {
    super (aDocType);
  }

  /**
   * Create a writer builder for {@link TDETOOPDataRequestType}.
   *
   * @return The builder and never <code>null</code>
   */
  @Nonnull
  public static ToopWriter<TDETOOPDataRequestType> dataRequest () {
    final ToopWriter<TDETOOPDataRequestType> ret = new ToopWriter<> (EToopXMLDocumentType.DATA_REQUEST);
    ret.setFormattedOutput (true);
    return ret;
  }

  /**
   * Create a writer builder for {@link TDETOOPDataResponseType}.
   *
   * @return The builder and never <code>null</code>
   */
  @Nonnull
  public static ToopWriter<TDETOOPDataResponseType> dataResponse () {
    final ToopWriter<TDETOOPDataResponseType> ret = new ToopWriter<> (EToopXMLDocumentType.DATA_RESPONSE);
    ret.setFormattedOutput (true);
    return ret;
  }
}
