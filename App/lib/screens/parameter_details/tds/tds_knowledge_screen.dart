import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class TDSKnowledgeScreen extends StatelessWidget {
  const TDSKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of TDS in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Total Dissolved Solids (TDS) refer to the combined content of all inorganic and organic substances contained in a liquid. In aquariums, TDS includes minerals, salts, and other compounds dissolved in the water, and is a key parameter in assessing water quality.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of TDS in Aquariums",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "TDS levels are crucial for the overall health of aquatic life. Different species have specific TDS requirements, and maintaining appropriate levels is essential for creating a suitable environment. TDS influences various aspects of the aquarium ecosystem:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Osmoregulation",
              "Fish rely on osmoregulation to maintain the balance of salts and water in their bodies. Incorrect TDS levels can disrupt this process, leading to stress and health issues for the fish (Evans, 2009)."),
          _buildBulletPoint(context, "Water Hardness",
              "TDS is directly related to water hardness, which affects the health and behavior of aquatic organisms. Hard water has high TDS due to dissolved minerals like calcium and magnesium, while soft water has low TDS (Boyd, 1990)."),
          _buildBulletPoint(context, "Plant Growth",
              "Aquatic plants require specific TDS levels for optimal nutrient uptake and growth. High TDS can inhibit plant growth by making nutrients less available, while low TDS can indicate a lack of necessary minerals (Raven et al., 1999)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of TDS on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "TDS levels can affect several key water parameters, each of which can impact the health of an aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "High TDS can buffer pH, making it more stable but also harder to adjust. Conversely, low TDS can result in larger pH fluctuations, which can stress fish and other aquatic organisms (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Conductivity",
              "TDS is directly related to the conductivity of water. Higher TDS increases water's ability to conduct electricity, which can be used as a proxy to measure TDS levels indirectly (APHA, 1998)."),
          _buildBulletPoint(context, "Oxygen Levels",
              "High TDS can reduce the solubility of oxygen in water, potentially leading to hypoxic conditions. It is important to maintain balanced TDS levels to ensure adequate oxygen availability (Wetzel, 2001)."),
          _buildBulletPoint(context, "Ammonia, Nitrite, and Nitrate",
              "Elevated TDS can indicate the presence of harmful substances like ammonia, nitrite, and nitrate, which are products of fish waste and uneaten food. Regular monitoring of TDS can help manage these toxic compounds (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Salinity",
              "In marine and brackish water aquariums, TDS includes salts contributing to salinity. Maintaining proper salinity is crucial for the health of marine organisms (Spotte, 1979)."),
          _buildBulletPoint(context, "General Hardness and Carbonate Hardness",
              "TDS affects both GH and KH, influencing the buffering capacity and overall hardness of the water. Balanced hardness is essential for the stability of the aquarium environment (Boyd, 1990)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about TDS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Monitoring TDS",
              "TDS meters are widely used to measure the total dissolved solids in water. They provide a quick and easy way to assess water quality and make necessary adjustments (APHA, 1998)."),
          _buildBulletPoint(context, "Source Water",
              "The TDS level of source water (tap water, well water, etc.) can vary significantly. It's important to test and, if necessary, treat source water before adding it to your aquarium to ensure it meets the needs of your aquatic life (Boyd, 1990)."),
          _buildBulletPoint(context, "Impact of Evaporation",
              "As water evaporates from the aquarium, the TDS concentration increases because dissolved solids remain behind. Regular water changes are essential to maintain stable TDS levels (Spotte, 1979)."),
          const SizedBox(height: 16),
          const Text(
            "References",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildReference(
            "APHA (1998). Standard Methods for the Examination of Water and Wastewater. American Public Health Association.",
          ),
          _buildReference(
            "Boyd, C. E. (1990). Water Quality in Ponds for Aquaculture. Auburn University.",
          ),
          _buildReference(
            "Emerson, K., Russo, R. C., Lund, R. E., & Thurston, R. V. (1975). Aqueous ammonia equilibrium calculations: effect of pH and temperature. Journal of the Fisheries Board of Canada, 32(12), 2379-2383.",
          ),
          _buildReference(
            "Evans, D. H. (2009). Osmotic and Ionic Regulation: Cells and Animals. CRC Press.",
          ),
          _buildReference(
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
          ),
          _buildReference(
            "Spotte, S. (1979). Fish and Invertebrate Culture: Water Management in Closed Systems. John Wiley & Sons.",
          ),
          _buildReference(
            "Wetzel, R. G. (2001). Limnology: Lake and River Ecosystems. Academic Press.",
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorProvider.n1),
                  ),
                  TextSpan(
                    text: text,
                    style:
                        const TextStyle(fontSize: 16, color: ColorProvider.n1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReference(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: ColorProvider.n1),
      ),
    );
  }
}
