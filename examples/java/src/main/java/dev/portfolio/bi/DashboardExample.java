package dev.portfolio.bi;

import java.util.List;
import java.util.Map;

public final class DashboardExample {
    private DashboardExample() {
    }

    public static void main(String[] args) {
        List<KpiCalculator.OrderMetric> orders = KpiCalculator.sampleData();
        KpiCalculator.KpiSummary totalSummary = KpiCalculator.summarize(orders);
        Map<String, KpiCalculator.KpiSummary> channelSummary = KpiCalculator.summarizeByChannel(orders);

        System.out.println("Resumo geral: " + totalSummary);
        System.out.println("Resumo por canal: " + channelSummary);
    }
}
