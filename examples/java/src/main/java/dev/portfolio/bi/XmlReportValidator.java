package dev.portfolio.bi;

import java.io.File;
import java.util.Arrays;
import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;

/**
 * Validador simples para confirmar se artefatos JasperReports estão bem formados.
 *
 * <p>A validação usa apenas APIs padrão do JDK e evita dependências externas.</p>
 */
public final class XmlReportValidator {
    private XmlReportValidator() {
    }

    public static void main(String[] args) throws Exception {
        String[] files = args.length == 0
                ? new String[] {
                    "reports/jrxml/kpi_summary_report.jrxml",
                    "themes/jasper/executive_theme.jrtx"
                }
                : Arrays.copyOf(args, args.length);

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
        factory.setNamespaceAware(true);

        for (String fileName : files) {
            File file = new File(fileName);
            factory.newDocumentBuilder().parse(file);
            System.out.println("OK " + file.getPath());
        }
    }
}
