import com.opencsv.CSVWriter;
import org.apache.pdfbox.pdmodel.PDDocument;
import technology.tabula.*;
import technology.tabula.extractors.SpreadsheetExtractionAlgorithm;

import java.io.*;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ExtractFileToCSV {

    public static void extractPdfToCsv(String folderPath, String csvFile) throws IOException {
        File dir = new File(folderPath);
        File[] files = dir.listFiles((d, name) -> name.contains("Anexo_I") && name.endsWith(".pdf"));

        if(files == null || files.length == 0) {
            System.out.println("Nenhum PDF encontrado para extração");
            return;
        }

        try(CSVWriter writer = new CSVWriter(new FileWriter(csvFile))) {
            for(File file : files) {
                PDDocument document = PDDocument.load(file);
                SpreadsheetExtractionAlgorithm algorithm = new SpreadsheetExtractionAlgorithm();
                PageIterator pages = new ObjectExtractor(document).extract();

                while (pages.hasNext()) {
                    Page page = pages.next();
                    Table table = algorithm.extract(page).get(0);

                    for (List<RectangularTextContainer> row : table.getRows()) {
                        String[] rowData = row.stream().map(RectangularTextContainer::getText).toArray(String[]::new);
                        writer.writeNext(rowData);

                    }
                }
                document.close();
            }
            System.out.println("Extração concluída e salva em " + csvFile);
        }

    }

    public static void zipCsvFile(String csvFilePath, String zipFilePath) throws IOException {
        FileOutputStream fos = new FileOutputStream(zipFilePath);
        ZipOutputStream zos = new ZipOutputStream(fos);
        File file = new File(csvFilePath);

        if(file.exists()) {
            FileInputStream fis = new FileInputStream(file);
            ZipEntry zipEntry = new ZipEntry(file.getName());
            zos.putNextEntry(zipEntry);

            byte[] buffer = new byte[1024];
            int length;
            while((length = fis.read(buffer)) >= 0) {
                zos.write(buffer, 0, length);
            }

            zos.closeEntry();
            fis.close();

        }
        zos.close();
        System.out.println("CSV compactado em " + zipFilePath);
    }


}
