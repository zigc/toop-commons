<?xml version="1.0" encoding="UTF-8"?>
<!--
    
    Copyright (C) 2018 toop.eu
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    queryBinding="xslt2" 
    >
    <title>TOOP Business Rules (specs Version 1.1.0)</title>
    <ns prefix="toop" uri="urn:eu:toop:ns:dataexchange-1p10"/>
    
    <!--Check for a valid split: only a DataElementRequest or a DocumentRequest-->
    <pattern>
        <rule context="toop:Request | toop:Response">
            <report test="( (exists(toop:DataElementRequest)) and (exists(toop:DocumentRequest)) )"  flag='ERROR' id="mandatory_split">
                The message cannot contain a request both for Data Elements and Documents. Please split the message.
            </report>
        </rule>
    </pattern>
    
    <!--Check the format of the UUID's-->
    <pattern>
        <rule context="toop:DocumentUniversalUniqueIdentifier | toop:DataRequestIdentifier | toop:DocumentRequestIdentifier">
            <assert test="matches(text(),'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$','i')" flag='ERROR' id="wrong_uuid_format">
                Rule: The UUID MUST be created following the UUID Version 4 specification. 
                Copies of a document must be identified with a different UUID. 
                Compulsory use of schemeAgencyID attribute.</assert>
        </rule>
    </pattern>
    
    <!--Check DataRequest specific rules-->
    <pattern>
        <rule context="toop:Request">
            <report test="exists(toop:DataRequestIdentifier)" flag='ERROR' id="misplaced_dr_id">
                A Request should not contain a DataRequestIdentifier, which is used in the response to link to the request.
            </report>
            <assert test="matches(toop:DocumentTypeIdentifier/text(),'urn:eu.toop.request.registeredorganization::1.10$')" flag='ERROR' id="mandatory_req_doc_id">
                A Request DocumentTypeIdentifier must be 'urn:eu:toop:ns:dataexchange-1p10::Request##urn:eu.toop.request.registeredorganization::1.10'.
            </assert>
            <report test="( (exists(//toop:DocumentResponse)) or (exists(//toop:DataElementResponseValue)) )"  flag='ERROR' id="misplaced_response">
                A Request can not contain a DocumentResponse or any DataElementResponseValue element.
            </report>
            <report test="exists(//toop:DataProvider)" flag='ERROR' id="misplaced_data_provider">
                A Request should not contain information about the DataProvider.
            </report>
            <assert test="matches(toop:SpecificationIdentifier/text(),'urn:eu:toop:ns:dataexchange-1p10::Request$')" flag='ERROR' id="mandatory_req_specs_id">
                Rule: A Toop data request MUST have the specification identifier "urn:eu:toop:ns:dataexchange-1p10::Request".
            </assert>
        </rule>
    </pattern>

    
    <!--Check DataResponse specific rules-->
    <pattern>
        <rule context="toop:Response">
            <assert test="exists(toop:DataRequestIdentifier)" flag='ERROR' id="mandatory_dr_id">
                A Response must contain a DataRequestIdentifier. 
                UNCHECKED: Use the same value that was used in the corresponding Toop Request (path: Request/DocumentUniversalUniqueIdentifier).
            </assert>
            <assert test="matches(toop:DocumentTypeIdentifier/text(),'urn:eu.toop.response.registeredorganization::1.10$')" flag='ERROR' id="mandatory_res_doc_id">
                A Response DocumentTypeIdentifier must be 'urn:eu:toop:ns:dataexchange-1p10::Response##urn:eu.toop.response.registeredorganization::1.10'.
            </assert>
            <report test="matches(toop:DataRequestIdentifier,toop:DocumentUniversalUniqueIdentifier)"  flag='ERROR' id="duplicate_req_id">
                The DocumentUniversalUniqueIdentifier cannot be identical to the DataRequestIdentifier (which is copied from the Request).
            </report>
            <assert test="matches(toop:SpecificationIdentifier/text(),'urn:eu:toop:ns:dataexchange-1p10::Response$')" flag='ERROR' id="mandatory_res_specs_id">
                Rule: A Toop data response MUST have the specification identifier "urn:eu:toop:ns:dataexchange-1p10::Response".
            </assert>
        </rule>
    </pattern>
    
    <!--Check the schemeID of the DocumentTypeIdentifier and SpecificationIdentifier-->
    <pattern>
        <rule context="toop:DocumentTypeIdentifier | toop:SpecificationIdentifier">
            <let name="varschemeID" value="@schemeID"/>
            <assert test="matches($varschemeID,'^toop-doctypeid-qns$')" flag='ERROR' id="mandatory_scheme_docid">
                Compulsory use of attributes schemeID "toop-doctypeid-qns" (instead of <value-of select="$varschemeID"/>).    
            </assert>
        </rule>
    </pattern>
    
    
    
    <!--Check the schemeID of the ProcessIdentifier-->
    <pattern>
        <rule context="toop:ProcessIdentifier">
            <let name="varschemeID" value="@schemeID"/>
            <assert test="matches($varschemeID,'^toop-procid-agreement$')" flag='ERROR' id="mandatory_scheme_processid">
                Compulsory use of attributes schemeID "toop-procid-agreement" (instead of <value-of select="$varschemeID"/>).    
            </assert>
        </rule>
    </pattern>
    
    <!--Check for the existance of the SchemeId attribute when mandatory-->
    <pattern>
        <rule context="toop:DCElectronicAddressIdentifier | toop:DPElectronicAddressIdentifier">
            <assert test="@schemeID"  flag='ERROR' id="mandatory_address_schemeid">
                Rule: An electronic address identifier MUST have a scheme identifier attribute. 
            </assert>
        </rule>
    </pattern>
    
    
    <!--Check the schemeID of the ElectronicAddressIdentifiers-->
    <pattern>
        <rule context="toop:DCElectronicAddressIdentifier | toop:DPElectronicAddressIdentifier">
            <let name="varschemeID" value="@schemeID"/>
            <assert test="matches($varschemeID,'^iso6523-actorid-upis$')" flag='ERROR' id="mandatory_scheme_address">
                Compulsory use of attributes schemeID "iso6523-actorid-upis" (instead of <value-of select="$varschemeID"/>). 
            </assert>
        </rule>
    </pattern>

    <!--Check if an identifier is valid according to the eIDAS specifications-->
    <pattern>
        <rule context="toop:LegalPersonUniqueIdentifier | toop:PersonIdentifier">
            <assert test="matches(text(),'^[a-z]{2}/[a-z]{2}/(.*?)$','i')"  flag='ERROR' id="wrong_id_format">
                Rule: The uniqueness identifier consists of:
                1. The first part is the Nationality Code of the identifier. This is one of the ISO 3166-1 alpha-2 codes, followed by a slash ("/"))
                2. The second part is the Nationality Code of the destination country or international organization. This is one of the ISO 3166-1 alpha-2 codes, followed by a slash ("/")
                3. The third part a combination of readable characters. This uniquely identifies the identity asserted in the country of origin but does not necessarily reveal any discernible correspondence with the subject's actual identifier (for example, username, fiscal number etc).
            </assert>
        </rule>
    </pattern>
    
    <!--Check for the existance of the SchemeAgencyId attribute when mandatory-->
    <pattern>
        <rule context="toop:DataConsumerDocumentIdentifier | toop:DPIdentifier | toop:DocumentUniversalUniqueIdentifier | toop:DCUniqueIdentifier | toop:DocumentIssuerIdentifier | toop:DataConsumerGlobalSessionIdentifier | toop:DataRequestIdentifier | toop:DocumentRequestIdentifier">
            <assert test="@schemeAgencyID"  flag='ERROR' id="mandatory_schemeagency">
                Rule: The schemeAgencyID attribute is mandatory. 
            </assert>
        </rule>
    </pattern>
    
    <!--Check for the ConceptDefinition of a DC concept-->
    <pattern>
        <rule context="toop:ConceptRequest">
            <!--        <let name="conceptNamespaces" value="count(toop:ConceptNamespace)"/>  -->
            <!--        <let name="conceptNames" value="count(./toop:ConceptName)"/> -->
            <let name="conceptDefinitions" value="count(./toop:ConceptDefinition)"/> 
            <report test="matches(toop:ConceptTypeCode,'DC') and ($conceptDefinitions!=1)"  flag='ERROR' id="wrong_dc_concept_def_cardinality">
                Rule: If the Concept Type Code is set on "Data Consumer" the cardinality of the ConceptDefinition element MUST be set to 1...1 (instead of <value-of select="$conceptDefinitions"/>).
            </report>
        </rule>
    </pattern>
    
    <!--Check if the AuthorizedRepresentativeIdentifier links to the personIdentifier-->
    <pattern>
        <rule context="toop:AuthorizedRepresentativeIdentifier">
            <assert test="text()=//toop:DataRequestSubject/toop:NaturalPerson/toop:PersonIdentifier"  flag='ERROR' id="unmatched_person_rep_id">
                Rule: Use the value that is used in the element: DataSubject/NaturalPerson/PersonIdentifier.
            </assert>
        </rule>
    </pattern>
    
    <!--Check the format of a e-mail address-->
    <pattern>
        <rule context="toop:ContactEmailAddress">
            <assert test="matches(text(),'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}','i')"  flag='warning' id="invalid_email">
                The e-mail address format looks invalid.
            </assert>
        </rule>
    </pattern>
    
    <!--Check the length of the LEI code.-->
    <pattern>
        <rule context="toop:LegalEntityIdentifier">
            <let name="varleilength" value="string-length(normalize-space(text()))"/>
            <assert test="$varleilength=20"  flag='warning' id="invalid_euid_length">
                The LEI code length should be 20 (instead of <value-of select="$varleilength"/>).
            </assert>
        </rule>
    </pattern>
    
    <!--Check the validity of a boolean value (true or false)-->
    <pattern>
        <rule context="toop:DataElementResponseValue//toop:ResponseIndicator | toop:ErrorIndicator | toop:CopyIndicator | toop:SemanticMappingExecutionIndicator | toop:AlternativeResponseIndicator">
            <assert test="( (matches(normalize-space(text()),'^true$','i')) or (matches(normalize-space(text()),'^false$','i')) )" flag='ERROR' id="value_is_true_or_false">
                The provided value should be a boolean: true or false. 
            </assert>
        </rule>
    </pattern>
    
    <!--Check for currency attribute-->
    <pattern>
        <rule context="toop:DataElementResponseValue//toop:ResponseAmount">
            <assert test="@currencyID"  flag='ERROR' id="mandatory_currency_id">
                Rule: The currencyID attribute is mandatory (e.g. "EUR"). 
            </assert>
        </rule>
    </pattern>
    
    <!--Check the validity of a numeric response-->
    <pattern>
        <rule context="toop:DataElementResponseValue//toop:ResponseNumeric">
            <report test="matches(normalize-space(text()),'%')" flag='ERROR' id="avoid_percentage">
                Rule: do not format the percentage "%" symbol with the response value, just provide a float value (e.g. 0.4).
            </report>
        </rule>
    </pattern>
    
    <!-- RULES USING CODELISTS -->
    
    <!--Check codelist for country-->
    <pattern> 
        <let name="countrycodes" value="document('..\codelists\std-gc\CountryIdentificationCode-2.1.gc')//Value[@ColumnRef='code']" />
        <let name="identifier" value='normalize-space(//toop:PersonIdentifier)'/>
        <rule context="toop:CountryCode" flag='ERROR' id='gc_check_country_countrycode'> 
            <assert test="$countrycodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">The country code must always be specified using the correct code list.</assert> 
        </rule> 
        <rule context="toop:LegalPersonUniqueIdentifier | toop:PersonIdentifier" flag='ERROR' id='gc_check_id_countrycode'>
            <assert test="$countrycodes//SimpleValue[normalize-space(.) = (tokenize($identifier,'/')[1])]">The country code in the first part of the identifier must always be specified using the correct code list (found:<value-of select="(tokenize($identifier,'/')[1])"/>).</assert> 
            <assert test="$countrycodes//SimpleValue[normalize-space(.) = (tokenize($identifier,'/')[2])]">The country code in the second part of the identifier must always be specified using the correct code list (found:<value-of select="(tokenize($identifier,'/')[2])"/>).</assert> 
        </rule>
    </pattern> 
    
    <!--Check codelist for data request subject type-->
    <pattern> 
        <let name="subjecttypecodes" value="document('..\codelists\gc\DataRequestSubjectTypeCode-CodeList.gc')//Value[@ColumnRef='code']" />
        <rule context="toop:DataRequestSubjectTypeCode" flag='ERROR' id='gc_check_subject_type_code'> 
            <assert test="$subjecttypecodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">A subject type code code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for gender-->
    <pattern> 
        <let name="gendertypecodes" value="document('..\codelists\gc\Gender-CodeList.gc')//Value[@ColumnRef='code']" />
        <rule context="toop:GenderCode" flag='ERROR' id='gc_check_gender_code'> 
            <assert test="$gendertypecodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">A gender type code code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for concept-->
    <pattern> 
        <let name="concepttypecodes" value="document('..\codelists\gc\ConceptTypeCode-CodeList.gc')//Value[@ColumnRef='code']" />
        <rule context="toop:ConceptTypeCode" flag='ERROR' id='gc_check_concept_code'> 
            <assert test="$concepttypecodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">A concept type code code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for currency-->
    <pattern> 
        <let name="currencytypecodes" value="document('..\codelists\std-gc\CurrencyCode-2.1.gc')//Value[@ColumnRef='code']" />
        <rule context="toop:ResponseAmount" flag='ERROR' id='gc_check_currency_code'> 
            <let name="varcurrencyID" value="@currencyID"/>
            <assert test="$currencytypecodes//SimpleValue[normalize-space(.) = $varcurrencyID]">A currency type code code must always be specified using the correct code list (found:<value-of select="$varcurrencyID"/>).</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for standard industrial class code-->
    <pattern> 
        <let name="industrialtypecodes" value="document('..\codelists\gc\StandardIndustrialClassCode-CodeList.gc')//Value[@ColumnRef='code']" />
        <rule context="toop:StandardIndustrialClassification" flag='warning' id='gc_check_industrial_code'> 
            <assert test="$industrialtypecodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">A standard industrial class type code code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for data element response error code-->
    <pattern> 
        <let name="dataelementresponseerrorcodes" value="document('..\codelists\gc\DataElementResponseErrorCode-CodeList.gc')//Value[@ColumnRef='code']" />
        <rule context="toop:DataElementResponseValue//toop:ErrorCode" flag='ERROR' id='gc_check_error_data_element_response'> 
            <assert test="$dataelementresponseerrorcodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">An error code code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for document response error code-->
    <pattern> 
        <let name="documentresponseerrorcodes" value="document('..\codelists\gc\DocumentResponseErrorCode-CodeList.gc')//Value[@ColumnRef='code']" />
        <rule context="toop:DocumentResponse//toop:ErrorCode" flag='ERROR' id='gc_check_error_document_response'> 
            <assert test="$documentresponseerrorcodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">An error code code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for document request type code-->
    <pattern> 
        <let name="docrequesttypecodes" value="document('..\codelists\gc\DocumentRequestTypeCode-CodeList.gc')//Value[@ColumnRef='code']" />
        <rule context="toop:DocumentRequestTypeCode | toop:DocumentTypeCode" flag='warning' id='gc_check_doc_req_type'> 
            <assert test="$docrequesttypecodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">A document request type code code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for mimetype code-->
    <pattern> 
        <let name="mimetypecodes" value="document('..\codelists\std-gc\BinaryObjectMimeCode-2.1.gc')//Value[@ColumnRef='code']" />
        <rule context="toop:PreferredDocumentMimeTypeCode | toop:DocumentMimeTypeCode" flag='warning' id='gc_check_doc_mime_type'> 
            <assert test="$mimetypecodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">A MIME type code code must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for process identifier-->
    <pattern> 
        <let name="processidcodes" value="document('..\codelists\dynamic\ToopProcessIdentifiers-v1.gc')//Value[@ColumnRef='id']" />
        <rule context="toop:ProcessIdentifier" flag='ERROR' id='gc_check_process_id'> 
            <assert test="$processidcodes//SimpleValue[normalize-space(.) = normalize-space(current()/.)]">A process identifier must always be specified using the correct code list.</assert> 
        </rule> 
    </pattern> 
    
    <!--Check codelist for SchemeAgencyID-->
    <pattern> 
        <let name="agencyids" value="document('..\codelists\dynamic\ToopParticipantIdentifierSchemes-v1.gc')//Value[@ColumnRef='iso6523']" />
        <rule context="toop:DCElectronicAddressIdentifier | toop:DPElectronicAddressIdentifier" flag='ERROR' id='mandatory_schemeagency_actors'> 
            <let name="thisId" value="@schemeAgencyID"/>
            <assert test="$agencyids//SimpleValue[normalize-space(.)] = @schemeAgencyID">A schemeAgencyID must always be specified using the correct code list (found:<value-of select="$thisId"/>).</assert> 
        </rule> 
    </pattern> 
    
</schema>