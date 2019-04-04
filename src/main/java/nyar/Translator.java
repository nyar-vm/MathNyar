package nyar;

public class Translator extends NyarBaseVisitor<String> {
    public String visitProgram(NyarParser.ProgramContext ctx) {
        String result = "";
        for (int i = 0; i < ctx.getChildCount(); i++) {
            result += this.visit(ctx.statement(i));
        }
        return result;
    }

    // ID '=' expr ';'
    public String visitAssign(NyarParser.AssignContext ctx) {
        String id = ctx.SYMBOL().getText();
        String value = this.visit(ctx.expression());
        //System.out.printf("Set[%s,%s];\n", id, value);
        return String.format("Set[%s,%s];\n", id, value);
    }

    public String visitAdd_Like(NyarParser.Add_LikeContext ctx) {
        String lhs = this.visit(ctx.expression(0));
        String op = ctx.op.getText();
        String rhs = this.visit(ctx.expression(1));
        //System.out.printf("Operator[%s,%s,%s];\n", op, lhs, rhs);
        switch (ctx.op.getType()) {
            case NyarParser.ADD:
                op = "Plus";
                break;
            case NyarParser.SUB:
                op = "Subtract";
                break;
            default:
                break;
        }
        return String.format("%s[%s,%s]", op, lhs, rhs);
    }

    public String visitNumber(NyarParser.NumberContext ctx) {
        //System.out.printf("%s\n", ctx.getText());
        return ctx.getText();
    }

    public String visitSymbol(NyarParser.SymbolContext ctx) {
        //System.out.printf("%s\n", ctx.getText());
        return ctx.getText();
    }
}