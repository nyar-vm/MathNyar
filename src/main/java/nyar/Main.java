package nyar;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

public class Main {
    public static void main(String[] args) throws Exception {
        CharStream input = args.length == 0
                ? CharStreams.fromFileName("test/easy.nyar")
                : CharStreams.fromStream(System.in);

        NyarLexer lexer = new NyarLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        NyarParser parser = new NyarParser(tokens);
        NyarVisitor translator = new Translator();
        System.out.println(translator.visit(parser.program()));
    }
}