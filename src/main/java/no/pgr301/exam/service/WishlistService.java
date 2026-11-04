package no.pgr301.exam.service;

import no.pgr301.exam.model.AnalyzeResponse;
import no.pgr301.exam.model.GiftAnalysis;
import org.springframework.stereotype.Service;
import io.micrometer.core.instrument.MeterRegistry;

import java.time.Instant;
import java.util.List;

@Service
public class WishlistService {

    private final S3Service s3;
    private final RekognitionService rekognition;
    private final BedrockService bedrock;
    private final MeterRegistry meterRegistry;

    public WishlistService(S3Service s3, RekognitionService rekognition, BedrockService bedrock, MeterRegistry meterRegistry) {
        this.s3 = s3;
        this.rekognition = rekognition;
        this.bedrock = bedrock;
        this.meterRegistry = meterRegistry;
    }

    public AnalyzeResponse process(byte[] bytes, String filename, String contentType) {
        String s3Key = s3.upload(bytes, filename, contentType);
        List<String> labels = rekognition.detectLabels(bytes);
        GiftAnalysis analysis = bedrock.suggestGifts(labels);
        
        meterRegistry.counter("app.gifts.suggested.total")
        .increment(analysis.suggestions().size());

        meterRegistry.summary("app.gifts.suggestions.per.analysis")
        .record(analysis.suggestions().size());

        return new AnalyzeResponse(
                s3Key,
                labels,
                analysis.roomAnalysis(),
                analysis.recipientProfile(),
                analysis.suggestions(),
                Instant.now().toString()
        );
    }
}
