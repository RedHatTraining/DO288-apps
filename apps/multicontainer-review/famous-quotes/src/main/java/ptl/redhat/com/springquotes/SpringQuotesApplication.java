package ptl.redhat.com.springquotes;

import com.opencsv.bean.CsvToBeanBuilder;
import com.opencsv.bean.HeaderColumnNameMappingStrategy;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Bean;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@Slf4j
@SpringBootApplication
public class SpringQuotesApplication {

    @Value("${quotes.import.path}")
    String importPath;

    public static void main(String[] args) {
        SpringApplication.run(SpringQuotesApplication.class, args);
    }

    @Bean
    ApplicationListener<ApplicationReadyEvent> readyEventApplicationListener(QuotesRepository quotesRepository) {
        return event -> {
           var quotes = importCSVifPresent();
            quotesRepository.saveAll(quotes)
                    .forEach(quote -> log.info("Imported on startup: " + quote));
        };
    }

    public List<Quote> importCSVifPresent() {

        List<Quote> quotes = Collections.emptyList();
        var strategy = new HeaderColumnNameMappingStrategy<Quote>();
        strategy.setType(Quote.class);

        try (FileReader reader = new FileReader(importPath)) {

            quotes = new CsvToBeanBuilder<Quote>(reader)
                    .withMappingStrategy(strategy)
                    .withSeparator('|')
                    .build()
                    .parse();

        } catch (FileNotFoundException e) {
            log.info("Data import file not found at " + importPath);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return quotes;
    }
}



