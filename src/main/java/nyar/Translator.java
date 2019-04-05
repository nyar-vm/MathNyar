package nyar;

public class Translator extends NyarBaseVisitor<String> {
    public String visitProgram(NyarParser.ProgramContext ctx) {
        String element = this.visit(ctx.elements());
        //System.out.print("Program: " + ctx.elements().getText() + "\n");
        return String.format("%s", element);
    }

    public String visitElements(NyarParser.ElementsContext ctx) {
        String result = "";
        for (int i = 0; i < ctx.getChildCount(); i++) {
            result += this.visit(ctx.element(i));
        }
        return result;
    }

    public String visitElement(NyarParser.ElementContext ctx) {
        String statement = this.visit(ctx.statement());
        //System.out.print("Element: " + ctx.statement().getText() + "\n");
        return String.format("%s", statement);
    }

    public String visitStatement(NyarParser.StatementContext ctx) {
        String result = "";
        if (ctx.block() != null) {
            result += this.visit(ctx.block());
            //System.out.print("Block: " + result + "\n");
        }
        if (ctx.emptyStatement() != null) {
            result += this.visit(ctx.emptyStatement());
            //System.out.print("Empty: " + result + "\n");
        }
        if (ctx.expressionStatement() != null) {
            result += this.visit(ctx.expressionStatement());
        }
        return String.format("%s;", result);
    }

    public String visitBlock(NyarParser.BlockContext ctx) {
        return visitChildren(ctx);
    }

    public String visitStatements(NyarParser.StatementsContext ctx) {
        return visitChildren(ctx);
    }

    public String visitEmptyStatement(NyarParser.EmptyStatementContext ctx) {
        return visitChildren(ctx);
    }

    public String visitExpressionStatement(NyarParser.ExpressionStatementContext ctx) {
        String expression = this.visit(ctx.expressionSequence());
        //System.out.print("Expression: " + expression + "\n");
        return String.format("%s", expression);
    }

    public String visitExpressionSequence(NyarParser.ExpressionSequenceContext ctx) {
        String result = "";
        for (int i = 0; i < ctx.getChildCount(); i++) {
            result += this.visit(ctx.expression(i));
        }
        return result;
    }

    public String visitPriorityOperation(NyarParser.PriorityOperationContext ctx) {
        String expression = this.visit(ctx.expression());
        System.out.print("Priority: " + ctx.expression().getText() + "\n");
        return String.format("%s", expression);
    }


    /*
    public String visitSingleStatement(NyarParser.SingleStatementContext ctx) {
        String expr = this.vsit(ctx.expression());
        //System.out.printf("Set[%s,%s];\n", id, value);
        return String.format("%s;\n", expr);
    }

    // ID '=' expr
    public String visitAssignStatement(NyarParser.AssignStatementContext ctx) {
        String id = ctx.SYMBOL().getText();
        String value = this.visit(ctx.expression());
        //System.out.printf("Set[%s,%s];\n", id, value);
        return String.format("Set[%s,%s];\n", id, value);
    }
    */

    public String visitPlus_Like(NyarParser.Plus_LikeContext ctx) {
        String lhs = this.visit(ctx.left);
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator: %s (%s,%s);\n", ctx.op.getText(), lhs, rhs);
        switch (ctx.op.getText()) {
            case "+":
                return String.format("Plus[%s,%s]", lhs, rhs);
            case "-":
                return String.format("Subtract[%s,%s]", lhs, rhs);
            default:
                return String.format("UnknowOperator[%s,%s]", lhs, rhs);
        }
    }

    public String visitMultiply_Like(NyarParser.Multiply_LikeContext ctx) {
        String lhs = this.visit(ctx.left);
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator: %s (%s,%s);\n", ctx.op.getText(), lhs, rhs);
        switch (ctx.op.getText()) {
            case "*":
                return String.format("Times[%s,%s]", lhs, rhs);
            case "/":
                return String.format("Divide[%s,%s]", lhs, rhs);
            default:
                return String.format("UnknowOperator[%s,%s]", lhs, rhs);
        }
    }

    public String visitPower_Like(NyarParser.Power_LikeContext ctx) {
        String lhs = this.visit(ctx.left);
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator: %s (%s,%s);\n", ctx.op.getText(), lhs, rhs);
        switch (ctx.op.getText()) {
            case "^":
                return String.format("Power[%s,%s]", lhs, rhs);
            case "√":
                return String.format("Surd[%s,%s]", rhs, lhs);
            default:
                return String.format("UnknowOperator[%s,%s]", lhs, rhs);
        }
    }

    public String visitNumber(NyarParser.NumberContext ctx) {
        //System.out.printf("%s\n", ctx.getText());
        switch (ctx.atom.getType()) {
            case NyarParser.INTEGER:
                return ctx.getText();
            case NyarParser.FLOAT:
                return ctx.getText();
            default:
                return ctx.getText();
        }
    }

    public String visitSymbol(NyarParser.SymbolContext ctx) {
        //System.out.printf("%s\n", ctx.getText());
        return ctx.getText();
    }

}