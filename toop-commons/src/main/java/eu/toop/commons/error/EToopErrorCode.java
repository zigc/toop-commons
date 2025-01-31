/**
 * Copyright (C) 2018-2019 toop.eu
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
package eu.toop.commons.error;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.lang.EnumHelper;

/**
 * Source: ErrorCode-CodeList.gc<br>
 * Content created by MainCreateJavaCode_ErrorCode_GC
 *
 * @author Philip Helger
 * @since 0.9.2
 */
public enum EToopErrorCode implements IToopErrorCode
{
  /** Uncategorized error */
  GEN ("GEN"),
  /** The payload provided from DC/DP to the TOOP Connector is not valid */
  IF_001 ("IF-001"),
  /** Message Validation Failed */
  IF_002 ("IF-002"),
  /** The Semantic Mapping Service is not reachable */
  SM_001 ("SM-001"),
  /**
   * The Semantic Mapping Service could not provide a mapping on provided
   * concepts
   */
  SM_002 ("SM-002"),
  /** The TOOP Directory is not reachable */
  DD_001 ("DD-001"),
  /** An SMP could not be queried */
  DD_002 ("DD-002"),
  /** Error validating a signature from SMP */
  DD_003 ("DD-003"),
  /**
   * The Dynamic Discovery Service was not able to find any Participant
   * Identifiers
   */
  DD_004 ("DD-004"),
  /**
   * At least one, but not all SMP Servers where not able to find a Service
   * Metadata
   */
  DD_005 ("DD-005"),
  /** None of the SMP Servers was able to find a Service Metadata */
  DD_006 ("DD-006"),
  /** Error creating the ASIC Container */
  TC_001 ("TC-001"),
  /**
   * The TOOP Connector was not able to communicate with the Local AS4 gateway
   */
  ME_001 ("ME-001"),
  /** The AS4 Gateway was not able to send the message */
  ME_002 ("ME-002"),
  /** The AS4 gateway could not deliver the message to the addressed gateway */
  ME_003 ("ME-003"),
  /** The AS4 gateway has not received a receipt */
  ME_004 ("ME-004");

  private final String m_sID;

  private EToopErrorCode (@Nonnull @Nonempty final String sID)
  {
    m_sID = sID;
  }

  @Nonnull
  @Nonempty
  public String getID ()
  {
    return m_sID;
  }

  @Nullable
  public static EToopErrorCode getFromIDOrNull (@Nullable final String sID)
  {
    return EnumHelper.getFromIDOrNull (EToopErrorCode.class, sID);
  }
}
