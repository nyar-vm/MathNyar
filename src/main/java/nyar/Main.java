package nyar;

import java.io.File;
import java.io.BufferedWriter;
import java.io.FileWriter;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

public class Main {
    public static void main(String[] args) throws Exception {

        String Test = "condition"; //"condition";
        CharStream input = CharStreams.fromFileName("test/" + Test + ".nyar");
        File output = new File("test/" + Test + ".m");

        NyarLexer lexer = new NyarLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        NyarParser parser = new NyarParser(tokens);
        NyarVisitor translator = new Translator();
        String MExpression = String.format("%s", translator.visit(parser.program()));
        System.out.print("========================================\n" + MExpression);

        try {
            BufferedWriter out = new BufferedWriter(new FileWriter(output));
            out.write(MExpression);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
