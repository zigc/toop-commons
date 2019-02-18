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
package eu.toop.commons.schematron;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.schematron.svrl.AbstractSVRLMessage;

import eu.toop.commons.codelist.EPredefinedDocumentTypeIdentifier;
import eu.toop.commons.codelist.EPredefinedProcessIdentifier;
import eu.toop.commons.concept.ConceptValue;
import eu.toop.commons.dataexchange.v120.TDEDataRequestSubjectType;
import eu.toop.commons.dataexchange.v120.TDETOOPRequestType;
import eu.toop.commons.dataexchange.v120.TDETOOPResponseType;
import eu.toop.commons.exchange.ToopMessageBuilder120;
import eu.toop.commons.jaxb.ToopWriter;
import eu.toop.commons.jaxb.ToopXSDHelper120;
import eu.toop.commons.usecase.regorg.ERegOrgConcept;
import oasis.names.specification.ubl.schema.xsd.unqualifieddatatypes_21.IdentifierType;

/**
 * Test class for class {@link TOOPSchematron120Validator}.
 *
 * @author Philip Helger
 */
public final class TOOPSchematron120ValidatorTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (TOOPSchematron120ValidatorTest.class);

  @Test
  public void testBasic ()
  {
    final TOOPSchematron120Validator v = new TOOPSchematron120Validator ();

    for (final String sFilename : new String [] { "data-request-document-example.xml",
                                                  "data-request-example.xml",
                                                  "data-request1.xml",
                                                  "data-response-document-example.xml",
                                                  "data-response-example.xml",
                                                  "data-response-with-ERROR-example.xml" })
    {
      LOGGER.info ("Checking " + sFilename);

      final FileSystemResource aFS = new FileSystemResource ("src/test/resources/xml/1.2.0/" + sFilename);
      assertTrue (aFS.exists ());

      final ICommonsList <AbstractSVRLMessage> aFAs = v.validateTOOPMessage (aFS);
      assertNotNull (aFAs);
      for (final AbstractSVRLMessage aFA : aFAs)
        LOGGER.info (aFA.toString ());
      assertTrue (aFAs.isEmpty ());
    }
  }

  @SuppressWarnings ("deprecation")
  @Test
  public void testValidateMockRequest ()
  {
    final String sDCCountryCode = "IT";
    final String sDPCountryCode = "AT";
    final TDEDataRequestSubjectType aRequestSubject = ToopMessageBuilder120.createMockDataRequestSubject (sDCCountryCode,
                                                                                                          sDPCountryCode,
                                                                                                          false,
                                                                                                          "id");
    final IdentifierType aSenderParticipantID = ToopXSDHelper120.createIdentifier ("iso6523-actorid-upis", "9915:bla");

    // Query all
    final ICommonsList <ConceptValue> aValues = new CommonsArrayList <> ();
    for (final ERegOrgConcept e : ERegOrgConcept.values ())
      aValues.add (e.getAsConceptValue ());

    final TDETOOPRequestType aRequestMsg = ToopMessageBuilder120.createMockRequest (aRequestSubject,
                                                                                    sDCCountryCode,
                                                                                    aSenderParticipantID,
                                                                                    EPredefinedDocumentTypeIdentifier.URN_EU_TOOP_NS_DATAEXCHANGE_1P10_REQUEST_URN_EU_TOOP_REQUEST_REGISTEREDORGANIZATION_1_10,
                                                                                    EPredefinedProcessIdentifier.DATAREQUESTRESPONSE,
                                                                                    aValues);
    assertNotNull (aRequestMsg);

    final Document aDoc = ToopWriter.request120 ().getAsDocument (aRequestMsg);
    assertNotNull (aDoc);

    // Schematron validation
    final TOOPSchematron120Validator aValidator = new TOOPSchematron120Validator ();
    final ICommonsList <AbstractSVRLMessage> aMsgs = aValidator.validateTOOPMessage (aDoc);
    for (final AbstractSVRLMessage aMsg : aMsgs)
      assertTrue (aMsg.getFlag () == EErrorLevel.WARN);
  }

  @SuppressWarnings ("deprecation")
  @Test
  public void testValidateMockResponse ()
  {
    final String sDCCountryCode = "IT";
    final String sDPCountryCode = "AT";
    final TDEDataRequestSubjectType aRequestSubject = ToopMessageBuilder120.createMockDataRequestSubject (sDCCountryCode,
                                                                                                          sDPCountryCode,
                                                                                                          false,
                                                                                                          "id");
    final IdentifierType aSenderParticipantID = ToopXSDHelper120.createIdentifier ("iso6523-actorid-upis", "9915:bla");

    // Query all
    final ICommonsList <ConceptValue> aValues = new CommonsArrayList <> ();
    for (final ERegOrgConcept e : ERegOrgConcept.values ())
      aValues.add (e.getAsConceptValue ());

    final TDETOOPResponseType aResponseMsg = ToopMessageBuilder120.createMockResponse (aSenderParticipantID,
                                                                                       aRequestSubject,
                                                                                       sDCCountryCode,
                                                                                       sDPCountryCode,
                                                                                       EPredefinedDocumentTypeIdentifier.URN_EU_TOOP_NS_DATAEXCHANGE_1P10_RESPONSE_URN_EU_TOOP_RESPONSE_REGISTEREDORGANIZATION_1_10,
                                                                                       EPredefinedProcessIdentifier.DATAREQUESTRESPONSE,
                                                                                       aValues);
    assertNotNull (aResponseMsg);

    final Document aDoc = ToopWriter.response120 ().getAsDocument (aResponseMsg);
    assertNotNull (aDoc);

    // Schematron validation
    final TOOPSchematron120Validator aValidator = new TOOPSchematron120Validator ();
    final ICommonsList <AbstractSVRLMessage> aMsgs = aValidator.validateTOOPMessage (aDoc);
    for (final AbstractSVRLMessage aMsg : aMsgs)
    {
      LOGGER.info (aMsg.getFlag () + "@" + aMsg.getLocation () + " - " + aMsg.getTest () + " / " + aMsg.getText ());
      assertTrue (aMsg.getFlag () == EErrorLevel.WARN);
    }
  }
}
