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

    /*
    public String visitBlockStatement(NyarParser.BlockStatementContext ctx) {
        StringBuilder result = new StringBuilder();
        //System.out.print("Expression: " + ctx.getText() + "\n");
        for (int i = 0; i < ctx.getChildCount() - 2; i++) {
            System.out.print("Statement: " + ctx.statement(i).getText() + "\n");
            result.append(this.visit(ctx.statement(i)));
        }
        return result.toString();
    }
    */
    public String visitEmptyStatement(NyarParser.EmptyStatementContext ctx) {
        //System.out.print("EmptyStatement!!\n");
        return "Null;";
    }


    public String visitExpressionStatement(NyarParser.ExpressionStatementContext ctx) {
        StringBuilder result = new StringBuilder();
        for (int i = 1; i < ctx.getChildCount(); i++) {
            //System.out.print("Expression: " + ctx.expression(i-1).getText() + "\n");
            result.append(this.visit(ctx.expression(i - 1)));
        }
        if (ctx.eos() != null) {
            return result.toString() + ";";
        } else {
            return result.toString();
        }
    }


    public String visitPriorityExpression(NyarParser.PriorityExpressionContext ctx) {
        String expression = this.visit(ctx.expression());
        //System.out.print("Priority: " + ctx.expression().getText() + "\n");
        return String.format("%s", expression);
    }


    public String visitPrefixExpression(NyarParser.PrefixExpressionContext ctx) {
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator: %s (%s);\n", ctx.op.getText(), rhs);
        switch (ctx.op.getText()) {
            case "+":
                return String.format("Plus[%s]", rhs);
            case "-":
                return String.format("Minus[%s]", rhs);
            case "!":
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
        switch (ctx.op.getText()) {
            case "+":
                return String.format("Plus[%s,%s]", lhs, rhs);
            case "-":
                return String.format("Subtract[%s,%s]", lhs, rhs);
            default:
                return String.format("UnknowOperator[%s,%s]", lhs, rhs);
        }
    }

    public String visitMultiplyLike(NyarParser.MultiplyLikeContext ctx) {
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

    public String visitPowerLike(NyarParser.PowerLikeContext ctx) {
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
        switch (ctx.op.getText()) {
            case ">":
                return String.format("Greater[%s,%s]", lhs, rhs);
            case "<":
                return String.format("Less[%s,%s]", lhs, rhs);
            case "==":
                return String.format("Equal[%s,%s]", lhs, rhs);
            case "!=":
                return String.format("Unequal[%s,%s]", lhs, rhs);
            default:
                return String.format("UnknowOperator[%s,%s]", lhs, rhs);
        }
    }

    /*
    public String visitIfStatement(NyarParser.IfStatementContext ctx) {
        int else_count = ctx.elseif().Else().size();
        int then_count = 0;
        if (ctx.Else() != null) {
            then_count += 1;
        }
        //System.out.printf("If Statement: %s\n", ctx.getText());
        //System.out.printf("ElseIf Count: %s\n", else_count + then_count);
        switch (else_count + then_count) {
            case 0: {
                String cond = this.visit(ctx.condition().expression());
                String then = this.visit(ctx.condition().expr_block());
                return String.format("Nyar`Core`If[%s,%s]", cond, then);
            }
            case 1: {
                String cond = this.visit(ctx.condition().expression());
                String then = this.visit(ctx.condition().expr_block());
                if (then_count == 1) {
                    return String.format(
                            "Nyar`Core`If[%s,%s,%s]", cond, then,
                            this.visit(ctx.expr_block())
                    );
                } else {
                    return String.format(
                            "Nyar`Core`ElseIf[%s,%s,%s,%s]", cond, then,
                            this.visit(ctx.elseif().condition(0).expression()),
                            this.visit(ctx.elseif().condition(0).expr_block())
                    );
                }
            }
            default: {
                String cond = this.visit(ctx.condition().expression());
                String then = this.visit(ctx.condition().expr_block());
                //String expr = this.visit(ctx.expr_block());
                String result = "Nyar`Core`ElseIf[" + cond + "," + then;
                for (int i = 0; i < else_count; i++) {
                    result += this.visit(ctx.elseif().condition(i).expression()) + ","
                            + this.visit(ctx.elseif().condition(i).expr_block()) + ",";
                    //result += this.visit(ctx.elseifStatement().condition(i));
                }
                if (then_count == 1) {
                    result += this.visit(ctx.expr_block()) + "]";
                } else {
                    result += "]";
                }
                return result;
            }
        }

    }*/
}