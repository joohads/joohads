package dev.portfolio.bi;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Calculadora genérica de KPIs para exemplos de BI.
 *
 * <p>Os dados usados aqui são sintéticos e representam apenas uma estrutura
 * comum de pedidos, canais e regiões. A classe evita dependências externas
 * para facilitar execução em qualquer ambiente com JDK.</p>
 */
public final class KpiCalculator {
    private KpiCalculator() {
    }

    public static KpiSummary summarize(List<OrderMetric> orders) {
        BigDecimal netRevenue = BigDecimal.ZERO;
        BigDecimal grossRevenue = BigDecimal.ZERO;
        int totalOrders = orders.size();

        for (OrderMetric order : orders) {
            netRevenue = netRevenue.add(order.getNetAmount());
            grossRevenue = grossRevenue.add(order.getGrossAmount());
        }

        BigDecimal averageTicket = totalOrders == 0
                ? BigDecimal.ZERO
                : netRevenue.divide(BigDecimal.valueOf(totalOrders), 2, RoundingMode.HALF_UP);

        return new KpiSummary(totalOrders, grossRevenue, netRevenue, averageTicket);
    }

    public static Map<String, KpiSummary> summarizeByChannel(List<OrderMetric> orders) {
        Map<String, List<OrderMetric>> groupedOrders = new LinkedHashMap<String, List<OrderMetric>>();

        for (OrderMetric order : orders) {
            String channel = order.getChannel() == null ? "nao_informado" : order.getChannel();
            if (!groupedOrders.containsKey(channel)) {
                groupedOrders.put(channel, new ArrayList<OrderMetric>());
            }
            groupedOrders.get(channel).add(order);
        }

        Map<String, KpiSummary> summaries = new LinkedHashMap<String, KpiSummary>();
        for (Map.Entry<String, List<OrderMetric>> entry : groupedOrders.entrySet()) {
            summaries.put(entry.getKey(), summarize(entry.getValue()));
        }
        return summaries;
    }

    public static List<OrderMetric> sampleData() {
        List<OrderMetric> orders = new ArrayList<OrderMetric>();
        orders.add(new OrderMetric("pedido_001", "cliente_001", "web", "sudeste", LocalDate.of(2026, 1, 5), "DELIVERED", bd("120.00"), bd("98.50")));
        orders.add(new OrderMetric("pedido_002", "cliente_002", "loja", "sul", LocalDate.of(2026, 1, 9), "PAID", bd("250.00"), bd("219.90")));
        orders.add(new OrderMetric("pedido_003", "cliente_001", "web", "sudeste", LocalDate.of(2026, 2, 12), "INVOICED", bd("180.00"), bd("160.00")));
        orders.add(new OrderMetric("pedido_004", "cliente_003", "parceiro", "nordeste", LocalDate.of(2026, 2, 18), "DELIVERED", bd("90.00"), bd("75.00")));
        return Collections.unmodifiableList(orders);
    }

    private static BigDecimal bd(String value) {
        return new BigDecimal(value);
    }

    public static final class OrderMetric {
        private final String orderId;
        private final String customerId;
        private final String channel;
        private final String region;
        private final LocalDate orderDate;
        private final String status;
        private final BigDecimal grossAmount;
        private final BigDecimal netAmount;

        public OrderMetric(String orderId, String customerId, String channel, String region, LocalDate orderDate,
                String status, BigDecimal grossAmount, BigDecimal netAmount) {
            this.orderId = orderId;
            this.customerId = customerId;
            this.channel = channel;
            this.region = region;
            this.orderDate = orderDate;
            this.status = status;
            this.grossAmount = grossAmount;
            this.netAmount = netAmount;
        }

        public String getOrderId() {
            return orderId;
        }

        public String getCustomerId() {
            return customerId;
        }

        public String getChannel() {
            return channel;
        }

        public String getRegion() {
            return region;
        }

        public LocalDate getOrderDate() {
            return orderDate;
        }

        public String getStatus() {
            return status;
        }

        public BigDecimal getGrossAmount() {
            return grossAmount;
        }

        public BigDecimal getNetAmount() {
            return netAmount;
        }
    }

    public static final class KpiSummary {
        private final int totalOrders;
        private final BigDecimal grossRevenue;
        private final BigDecimal netRevenue;
        private final BigDecimal averageTicket;

        public KpiSummary(int totalOrders, BigDecimal grossRevenue, BigDecimal netRevenue, BigDecimal averageTicket) {
            this.totalOrders = totalOrders;
            this.grossRevenue = grossRevenue;
            this.netRevenue = netRevenue;
            this.averageTicket = averageTicket;
        }

        public int getTotalOrders() {
            return totalOrders;
        }

        public BigDecimal getGrossRevenue() {
            return grossRevenue;
        }

        public BigDecimal getNetRevenue() {
            return netRevenue;
        }

        public BigDecimal getAverageTicket() {
            return averageTicket;
        }

        @Override
        public String toString() {
            return "KpiSummary{"
                    + "totalOrders=" + totalOrders
                    + ", grossRevenue=" + grossRevenue
                    + ", netRevenue=" + netRevenue
                    + ", averageTicket=" + averageTicket
                    + '}';
        }
    }
}
