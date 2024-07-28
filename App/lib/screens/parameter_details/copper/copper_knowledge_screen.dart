import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class CopperKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Copper in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Copper (Cu) is a trace element that can be both beneficial and harmful to aquatic life. It is often used as a medication to treat parasitic infections in fish, but elevated levels can be toxic to fish, invertebrates, and plants.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Copper in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Copper is used in controlled amounts to treat diseases such as ich and velvet in fish. However, maintaining appropriate copper levels is essential because excessive copper can lead to toxicity. Understanding and controlling copper is crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Disease Treatment",
              "Copper is effective in treating parasitic infections, providing a necessary tool for aquarium health management (Noga, 2010)."),
          _buildBulletPoint(context, "Toxicity",
              "High copper levels are toxic to fish, invertebrates, and plants, causing damage to gills, organs, and overall health. Monitoring copper levels is crucial to prevent toxicity (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Trace Nutrient",
              "In very small amounts, copper is a necessary trace nutrient for the physiological functions of fish and other aquatic organisms (Boyd, 1990)."),
          SizedBox(height: 16),
          Text(
            "Effects of Copper on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Copper levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "Copper's toxicity can increase with lower pH levels, making it more harmful in acidic conditions (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Water Hardness",
              "Higher water hardness can reduce the toxicity of copper by binding free copper ions, making them less available and harmful to aquatic life (Boyd, 1990)."),
          _buildBulletPoint(context, "Alkalinity",
              "Similar to water hardness, higher alkalinity can mitigate the toxic effects of copper by reducing the concentration of free copper ions (Hargreaves & Tucker, 2004)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Copper",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Copper Test Kits",
              "Using copper test kits helps monitor copper levels in the aquarium, ensuring they remain within safe limits (APHA, 1998)."),
          _buildBulletPoint(context, "Copper Removal",
              "Activated carbon, water changes, and specific chemical treatments can be used to remove excess copper from the aquarium (Boyd, 1990)."),
          _buildBulletPoint(context, "Species Sensitivity",
              "Different species have varying tolerances to copper. Invertebrates such as shrimp and snails are particularly sensitive to copper, requiring careful monitoring (Noga, 2010)."),
          SizedBox(height: 16),
          Text(
            "References",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
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
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "Noga, E. J. (2010). Fish Disease: Diagnosis and Treatment. John Wiley & Sons.",
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
