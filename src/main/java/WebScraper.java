import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import javax.net.ssl.HttpsURLConnection;
import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class WebScraper {

    private static final String BASE_URL = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos";
    private static final String DOWNLOAD_DIR = "downloads";
    private static final String ZIP_FILE = DOWNLOAD_DIR + File.separator + "anexos.zip";
    private static final String CSV_FILE = DOWNLOAD_DIR + File.separator + "procedimentos.csv";
    private static final String CSV_ZIP_FILE = DOWNLOAD_DIR + File.separator + "csv_anexos.zip";

    public static void main(String[] args) {
        try {
            Document doc = Jsoup.connect(BASE_URL).get();
            Elements links = doc.select("a");

            criarDiretorio(DOWNLOAD_DIR);

            for (Element link : links) {
                String url = link.absUrl("href");
                if (ehArquivoPdfValido(url)) {
                    baixarArquivo(url, DOWNLOAD_DIR);
                }
            }

            compactarArquivos(DOWNLOAD_DIR, ZIP_FILE);

            if (verificarPaginaExistente(BASE_URL)) {
                ExtractFileToCSV.extractPdfToCsv(DOWNLOAD_DIR, CSV_FILE);
                ExtractFileToCSV.zipCsvFile(CSV_FILE, CSV_ZIP_FILE);
            } else {
                System.out.println("A página não existe. Verifique o endereço.");
            }

            System.out.println("Download, extração e compactação concluídos!");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void criarDiretorio(String dir) throws IOException {
        Files.createDirectories(Paths.get(dir));
    }

    private static boolean ehArquivoPdfValido(String url) {
        return url.endsWith(".pdf") && (url.contains("Anexo_I") || url.contains("Anexo_II")) && !url.endsWith(".xlsx");
    }

    private static void baixarArquivo(String fileUrl, String saveDir) throws IOException {
        URL url = new URL(fileUrl);

        HttpsURLConnection httpConn = (HttpsURLConnection) url.openConnection();
        int responseCode = httpConn.getResponseCode();

        if (responseCode == HttpsURLConnection.HTTP_OK) {
            String fileName = new File(url.getPath()).getName();
            InputStream inputStream = httpConn.getInputStream();
            FileOutputStream outputStream = new FileOutputStream(saveDir + File.separator + fileName);

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

            outputStream.close();
            inputStream.close();
            System.out.println("Arquivo baixado: " + fileName);
        }

        httpConn.disconnect();
    }

    private static void compactarArquivos(String sourceDir, String zipFile) throws IOException {
        FileOutputStream fos = new FileOutputStream(zipFile);
        ZipOutputStream zos = new ZipOutputStream(fos);
        File dir = new File(sourceDir);

        for (File file : dir.listFiles()) {
            if (!file.getName().endsWith(".xlsx")) {
                FileInputStream fis = new FileInputStream(file);
                ZipEntry zipEntry = new ZipEntry(file.getName());
                zos.putNextEntry(zipEntry);

                byte[] buffer = new byte[1024];
                int length;
                while ((length = fis.read(buffer)) >= 0) {
                    zos.write(buffer, 0, length);
                }

                zos.closeEntry();
                fis.close();
            }
        }
        zos.close();
        System.out.println("Arquivos compactados em: " + zipFile);
    }

    private static boolean verificarPaginaExistente(String url) {
        try {
            URL urlObj = new URL(url);
            HttpsURLConnection httpConn = (HttpsURLConnection) urlObj.openConnection();
            int responseCode = httpConn.getResponseCode();
            return responseCode == HttpsURLConnection.HTTP_OK;
        } catch (IOException e) {
            return false;
        }
    }
}