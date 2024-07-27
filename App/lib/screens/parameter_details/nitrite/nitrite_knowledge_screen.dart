import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class NitriteKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Nitrite in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Nitrite (NO2-) is an intermediate compound in the nitrogen cycle, which is essential for breaking down waste products in the aquarium. It is produced by the oxidation of ammonia by nitrifying bacteria. Nitrite is toxic to fish and other aquatic organisms, making its monitoring and management critical.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Nitrite in Aquariums",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Nitrite is part of the nitrogen cycle, where it is converted by beneficial bacteria into nitrate (NO3-), which is less harmful. However, elevated nitrite levels can be dangerous for aquatic life. Understanding and controlling nitrite is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Toxicity",
              "Nitrite is toxic to fish, impairing their ability to transport oxygen in the blood, leading to a condition known as 'brown blood disease.' Even low concentrations can cause stress and harm (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Nitrogen Cycle",
              "Nitrite is a key part of the nitrogen cycle, which is essential for breaking down fish waste. Proper biological filtration ensures nitrite is efficiently converted to nitrate by nitrifying bacteria (Hagopian & Riley, 1998)."),
          _buildBulletPoint(context, "Indicator of Water Quality",
              "Elevated nitrite levels indicate an imbalance in the nitrogen cycle, often caused by overfeeding, overstocking, or inadequate filtration. It serves as a warning sign that corrective actions are needed (Boyd, 1990)."),
          SizedBox(height: 16),
          Text(
            "Effects of Nitrite on Other Water Parameters",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Nitrite levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "High nitrite levels can lead to an acidic environment as it is converted to nitrate. This can cause pH fluctuations that stress aquatic life (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Ammonia and Nitrate Levels",
              "Nitrite levels are directly influenced by the levels of ammonia, which is converted to nitrite, and the levels of nitrate, which nitrite is converted into. Managing ammonia effectively helps control nitrite levels (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Oxygen Levels",
              "Nitrite can interfere with the oxygen-carrying capacity of fish blood, leading to reduced oxygen availability and increased respiratory distress. Adequate oxygenation is essential to mitigate nitrite toxicity (Wetzel, 2001)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Nitrite",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Nitrite Detoxifiers",
              "Products that detoxify nitrite can provide temporary relief in emergencies, but they do not replace the need for proper biological filtration and regular maintenance (APHA, 1998)."),
          _buildBulletPoint(context, "Fishless Cycling",
              "Cycling an aquarium without fish allows beneficial bacteria to establish and process nitrite, creating a safer environment before introducing fish (Hagopian & Riley, 1998)."),
          _buildBulletPoint(context, "Nitrite Test Kits",
              "Regular use of nitrite test kits helps monitor water quality and detect problems early, allowing for timely corrective actions (Boyd, 1990)."),
          SizedBox(height: 16),
          Text(
            "References",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
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
            "Hagopian, D. S., & Riley, J. G. (1998). A closer look at the bacteriology of nitrification. Aquacultural Engineering, 18(4), 223-244.",
          ),
          _buildReference(
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
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
          Text(
            '• ',
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorProvider.primaryDark),
                  ),
                  TextSpan(
                    text: text,
                    style:
                        TextStyle(fontSize: 16, color: ColorProvider.textDark),
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
        style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
      ),
    );
  }
}
