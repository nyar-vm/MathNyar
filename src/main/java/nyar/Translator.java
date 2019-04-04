package nyar;

public class Translator extends NyarBaseVisitor<String> {
    public String visitProgram(NyarParser.ProgramContext ctx) {
        String result = "";
        for (int i = 0; i < ctx.getChildCount(); i++) {
            result += this.visit(ctx.element(i));
        }
        return result;
    }

    public String visitSingleStatement(NyarParser.SingleStatementContext ctx) {
        String expr = this.visit(ctx.expression());
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

    public String visitPlus_Like(NyarParser.Plus_LikeContext ctx) {
        String lhs = this.visit(ctx.left);
        String rhs = this.visit(ctx.right);
        //System.out.printf("Operator[%s,%s,%s];\n", ctx.op.getText(), lhs, rhs);
        System.out.print(ctx.op.getText());
        switch (ctx.op.getType()) {
            case NyarParser.Plus:
                return String.format("Plus[%s,%s]", lhs, rhs);
            case NyarParser.Minus:
                return String.format("Plus[%s,%s]", lhs, rhs);
            default:
                return "";
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