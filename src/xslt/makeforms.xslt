<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:f="http://xmlns.greystate.dk/2024/forms"
	exclude-result-prefixes="f"
>
	<xsl:output method="html" indent="yes" omit-xml-declaration="yes" />

	<xsl:template match="f:forms">
		<nav>
			<ul>
				<xsl:for-each select="f:form">
					<li><a href="#search-{@id}"><xsl:value-of select="f:name" /></a></li>
				</xsl:for-each>
			</ul>
		</nav>

		<main>
			<xsl:apply-templates />
		</main>
	</xsl:template>

	<xsl:template match="f:form">
		<article id="search-{@id}">
			<header>
				<h2><xsl:value-of select="f:name" /></h2>
			</header>

			<form target="_blank">
				<xsl:copy-of select="@action | @method" />
				<xsl:if test="@allow-default = 'yes'"><xsl:attribute name="data-allow-default" /></xsl:if>
				<xsl:apply-templates />

				<p class="submission">
					<button type="submit">Search</button>
				</p>
			</form>
		</article>
	</xsl:template>

	<xsl:template match="f:textfield">
		<xsl:variable name="fieldId" select="concat(ancestor::f:form/@id, '-', @name)" />
		<label for="{$fieldId}"><xsl:value-of select="@label" /></label>
		<input name="{@name}" type="search" placeholder="{@placeholder}" id="{$fieldId}">
			<xsl:if test="@autofocus = 'yes'"><xsl:attribute name="autofocus" /></xsl:if>
		</input>
	</xsl:template>

	<xsl:template match="f:secret">
		<xsl:variable name="fieldId" select="concat(ancestor::f:form/@id, '-', @name)" />
		<label for="{$fieldId}"><xsl:value-of select="@label" /></label>
		<input name="{@name}" type="password" id="{$fieldId}">
			<xsl:if test="@allow-storage = 'yes'">
				<xsl:attribute name="data-allow-storage">yes</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="$fieldId" /></xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>

	<xsl:template match="f:group">
		<fieldset>
			<legend><xsl:value-of select="@legend" /></legend>
			<xsl:apply-templates />
		</fieldset>
	</xsl:template>

	<xsl:template match="f:group[@collapse = 'yes']">
		<details>
			<summary><xsl:value-of select="@legend" /></summary>
			<xsl:apply-templates />
		</details>
	</xsl:template>

	<xsl:template match="f:picker[@type = 'single']">
		<xsl:for-each select="f:option">
			<xsl:variable name="optionId" select="concat(../@name, '-', @value)" />
			<div>
				<input type="radio" id="{$optionId}">
					<xsl:copy-of select="@name | @value" />
					<xsl:if test="position() = 1"><xsl:attribute name="checked" /></xsl:if>
				</input>
				<label for="{$optionId}"><xsl:value-of select="." /></label>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="f:toggle">
		<xsl:variable name="toggleId" select="concat(@name, '-', @value)" />
		<div>
			<input type="checkbox" name="{@name}" value="{@value}" id="{$toggleId}" />
			<label for="{$toggleId}"><xsl:value-of select="." /></label>
		</div>
	</xsl:template>

	<xsl:template match="f:data">
		<input type="hidden" name="{@name}" value="{@value}" />
	</xsl:template>

	<xsl:template match="f:text">
		<xsl:apply-templates select="* | text()" mode="identity" />
	</xsl:template>

	<xsl:template match="f:divider">
		<hr />
	</xsl:template>


	<!-- Ignore (handled inline/elsewhere) -->
	<xsl:template match="f:name" />

	<!-- Modified Identity Transform (output in no namespace) -->
	<xsl:template match="*" mode="identity">
		<xsl:element name="{local-name()}">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="* | text()" mode="identity" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="text()" mode="identity">
		<xsl:value-of select="." />
	</xsl:template>



</xsl:stylesheet>
