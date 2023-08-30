package ptl.redhat.com.springquotes;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.redis.core.RedisHash;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@Data
@RedisHash("Quotes")
public class Quote {

    private Long id;

    private String quote;

    private String author;

}

@RepositoryRestResource(path = "quotes")
interface QuotesRepository extends CrudRepository<Quote, Long> {
}