package nyar;

public class Translator extends NyarBaseVisitor<String> {
    public String visitProgram(NyarParser.ProgramContext ctx) {
        StringBuilder result = new StringBuilder();
        for (int i = 1; i < ctx.getChildCount(); i++) {
            //System.out.print("Statement: " + ctx.statement(i-1).getText() + "\n");
            result.append(this.visit(ctx.statement(i - 1))).append('\n');
        }
        return result.toString();
    }

    public String visitStatement(NyarParser.StatementContext ctx) {
        //System.out.print("Statement: " + ctx.getText() + "\n");
        if (ctx.eos() != null) {
            return this.visit(ctx.getChild(0)) + ";";
        } else {
            return this.visit(ctx.getChild(0));
        }
    }


    public String visitBlockStatement(NyarParser.BlockStatementContext ctx) {
        StringBuilder result = new StringBuilder();
        //System.out.print("Block: " + ctx.getText() + "\n");
        for (int i = 0; i < ctx.statement().size(); i++) {
            result.append(this.visitStatement(ctx.statement(i)));
        }
        return result.toString();
    }


    public String visitEmptyStatement(NyarParser.EmptyStatementContext ctx) {
        //System.out.print("EmptyStatement!!\n");
        return "Null;";
    }


    public String visitExpressionStatement(NyarParser.ExpressionStatementContext ctx) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < ctx.expression().size(); i++) {
            //System.out.print("Expression: " + ctx.expression(i).getText() + "\n");
            result.append(this.visit(ctx.expression(i)));
        }
        return result.toString();
    }


    public String visitPriorityExpression(NyarParser.PriorityExpressionContext ctx) {
        String expression = this.visit(ctx.expression());
        //System.out.print("Priority: " + ctx.expression().getText() + "\n");
        return String.format("%s", expression);
    }


    public String visitPrefixExpression(NyarParser.PrefixExpressionContext ctx) {
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator: %s (%s);\n", ctx.op.getType(), rhs);
        switch (ctx.op.getType()) {
            case NyarParser.Plus:
                return String.format("Plus[%s]", rhs);
            case NyarParser.Minus:
                return String.format("Minus[%s]", rhs);
            case NyarParser.LogicNot:
                return String.format("Not[%s]", rhs);
            default:
                return String.format("UnknowOperator[%s]", rhs);
        }
    }


    public String visitOperatorAssign(NyarParser.OperatorAssignContext ctx) {
        String id = ctx.id.getText();
        String expr = this.visit(ctx.expr);
        //System.out.printf("Set[%s,%s];\n", id, expr);
        return String.format("Set[%s,%s]", id, expr);
    }


    public String visitPlusLike(NyarParser.PlusLikeContext ctx) {
        String lhs = this.visit(ctx.left);
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator: %s (%s,%s);\n", ctx.op.getText(), lhs, rhs);
        switch (ctx.op.getType()) {
            case NyarParser.Plus:
                return String.format("Plus[%s,%s]", lhs, rhs);
            case NyarParser.Minus:
                return String.format("Subtract[%s,%s]", lhs, rhs);
            default:
                return String.format("UnknowOperator[%s,%s]", lhs, rhs);
        }
    }


    public String visitMultiplyLike(NyarParser.MultiplyLikeContext ctx) {
        String lhs = this.visit(ctx.left);
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator: %s (%s,%s);\n", ctx.op.getText(), lhs, rhs);
        switch (ctx.op.getType()) {
            case NyarParser.Times:
                return String.format("Times[%s,%s]", lhs, rhs);
            case NyarParser.Divide:
                return String.format("Divide[%s,%s]", lhs, rhs);
            default:
                return String.format("UnknowOperator[%s,%s]", lhs, rhs);
        }
    }


    public String visitPowerLike(NyarParser.PowerLikeContext ctx) {
        String lhs = this.visit(ctx.left);
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator: %s (%s,%s);\n", ctx.op.getText(), lhs, rhs);
        switch (ctx.op.getType()) {
            case NyarParser.Power:
                return String.format("Power[%s,%s]", lhs, rhs);
            case NyarParser.Surd:
                return String.format("Surd[%s,%s]", rhs, lhs);
            default:
                return String.format("UnknowOperator[%s,%s]", lhs, rhs);
        }
    }


    public String visitNumber(NyarParser.NumberContext ctx) {
        //System.out.printf("%s\n", ctx.getText());
        switch (ctx.atom.getType()) {
            case NyarParser.Integer:
                return ctx.getText();
            case NyarParser.Float:
                return ctx.getText();
            default:
                return ctx.getText();
        }
    }


    public String visitSymbol(NyarParser.SymbolContext ctx) {
        //System.out.printf("%s\n", ctx.getText());
        return ctx.getText();
    }


    public String visitLogicLike(NyarParser.LogicLikeContext ctx) {
        String lhs = this.visit(ctx.left);
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator: %s (%s,%s);\n", ctx.op.getText(), lhs, rhs);
        switch (ctx.op.getType()) {
            case NyarParser.Grater:
                return String.format("Greater[%s,%s]", lhs, rhs);
            case NyarParser.Less:
                return String.format("Less[%s,%s]", lhs, rhs);
            case NyarParser.Equal:
                return String.format("Equal[%s,%s]", lhs, rhs);
            case NyarParser.NotEqual:
                return String.format("Unequal[%s,%s]", lhs, rhs);
            default:
                return String.format("UnknowOperator[%s,%s]", lhs, rhs);
        }
    }


    public String visitConditionStatement(NyarParser.ConditionStatementContext ctx) {
        //System.out.print("Condition: " + ctx.getText() + '\n');
        return this.visit(ctx.expression());
    }


    public String visitIfSingle(NyarParser.IfSingleContext ctx) {
        String cond = this.visit(ctx.condition_statement());
        String then = this.visit(ctx.expr_or_block());
        if (ctx.else_statement() != null) {
            //System.out.printf("IfElse: %s\n", ctx.getText());
            String otherwise = this.visit(ctx.else_statement());
            return String.format("Nyar`Core`If[%s,%s,%s]", cond, then, otherwise);
        } else {
            //System.out.printf("If: %s\n", ctx.getText());
            return String.format("Nyar`Core`If[%s,%s]", cond, then);
        }
    }


    public String visitIfNested(NyarParser.IfNestedContext ctx) {
        String cond = this.visit(ctx.condition_statement());
        String then = this.visit(ctx.expr_or_block());
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < ctx.if_elseif().size(); i++) {
            //System.out.print("IfNested: " + ctx.if_elseif(i).getText() + '\n');
            result.append(this.visit(ctx.if_elseif(i)));
        }
        if (ctx.else_statement() != null) {
            String otherwise = this.visit(ctx.else_statement());
            return String.format("Nyar`Core`ElseIf[%s,%s,%s%s]", cond, then, result.toString(), otherwise);
        } else {
            result = new StringBuilder(result.substring(0, result.length() - 1));
            return String.format("Nyar`Core`ElseIf[%s,%s,%s]", cond, then, result.toString());
        }
    }


    public String visitElseIfStatement(NyarParser.ElseIfStatementContext ctx) {
        String cond = this.visit(ctx.condition_statement());
        String expr = this.visit(ctx.expr_or_block());
        return cond + ',' + expr + ',';
    }
}