package nyar

import java.util

import scala.collection.JavaConverters._

class Translator extends NyarBaseVisitor[String] {
	override def visitProgram(ctx: NyarParser.ProgramContext): String = {
		ctx.statement()
			.asScala.map(this.visit).dropWhile(_ == "")
			.mkString("\n").replaceAll("\n\n*", "\n")
	}

	override def visitStatement(ctx: NyarParser.StatementContext): String = {
		//System.out.print("Statement: " + ctx.getText + "\n")
		if (ctx.eos != null) {
			this.visit(ctx.getChild(0)) + ";"
		}
		else {
			this.visit(ctx.getChild(0))
		}
	}


	// region Data
	override def visitList(ctx: NyarParser.ListContext): String = {
		System.out.print("List: " + ctx.getText + "\n")
		val line = ctx.listLine()
		if (line == null) {
			return "{ }"
		}
		val list = line.element().asScala.map(this.visit)
		if (ctx.getText.length < 120) {
			'{' + list.mkString(", ") + '}'
		}
		else {
			s"""{\n${list.mkString(",").replaceAll("(?m)^", "    ")}\n}"""
		}
	}

	override def visitMatrix(ctx: NyarParser.MatrixContext): String = {
		def getLine(line: NyarParser.ListLineContext): String = {
			val list = line.element().asScala.map(this.visit)
			if (line.getText.length < 120) {
				'{' + list.mkString(", ") + '}'
			}
			else {
				s"""{\n${list.mkString(",").replaceAll("(?m)^", "    ")}\n}"""
			}
		}

		val lines = ctx.listLine().asScala.map(getLine)
		if (ctx.getText.length < 120) {
			'{' + lines.mkString(", ") + '}'
		}
		else {
			s"""{\n${lines.mkString(",\n").replaceAll("(?m)^", "    ")}\n}"""
		}
	}

	override def visitIndex(ctx: NyarParser.IndexContext): String = s"""(*  ParserError: \n${ctx.getText.replaceAll("(?m)^", "    ")}\n*)"""

	// endregion

	// region Basic
	override def visitNumber(ctx: NyarParser.NumberContext): String = {
		if (ctx.integer() != null) {
			//System.out.print("Integer: " + ctx.getText + "\n")
			return ctx.integer().getText
		}
		if (ctx.decimal() != null) {
			//System.out.print("Decimal: " + ctx.getText + "\n")
			val n = ctx.decimal().getText
			if (n.substring(n.length - 1, n.length) == ".") {
				return BigDecimal(n + "0").toString()
			}
			else {
				return BigDecimal(n).toString()
			}
		}

		System.out.print("Number: " + ctx.getText + "\n")
		s"""(*  ParserError: \n${ctx.getText.replaceAll("(?m)^", "    ")}\n*)"""
	}

	override def visitSpecial(ctx: NyarParser.SpecialContext): String = ctx.getText match {
		case "true" => "True"
		case "false" => "False"
		case "null" => "Null"
		case "nothing" => "Nothing"
	}

	override def visitEmptyStatement(ctx: NyarParser.EmptyStatementContext): String = ""

	override def visitComment(ctx: NyarParser.CommentContext): String = {
		val text = ctx.getText
		val s = if (text.head == '#') {
			text.substring(2, text.length).trim
		}
		else {
			text.substring(3, text.length - 3).trim
		}
		if (s.contains('\n')) {
			"(*\n" + s + "\n*)"
		}
		else {
			"(* " + s + " *)"
		}
	}

	// endregion
}
