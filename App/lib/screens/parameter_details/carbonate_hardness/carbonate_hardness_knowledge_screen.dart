import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class CarbonateHardnessKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Carbonate Hardness in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Carbonate hardness (KH), also known as alkalinity, refers to the concentration of carbonate (CO3) and bicarbonate (HCO3) ions in water. It plays a critical role in stabilizing pH levels and maintaining a healthy environment for aquarium inhabitants.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Carbonate Hardness in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Carbonate hardness buffers the water against sudden changes in pH, ensuring a stable environment for fish and plants. Maintaining appropriate KH levels is crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "pH Stability",
              "KH stabilizes pH by neutralizing acids in the water, preventing sudden fluctuations that can stress or harm aquatic life (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Fish Health",
              "Stable pH levels supported by adequate KH are essential for the physiological functions of fish, including respiration, metabolism, and overall health (Boyd, 1990)."),
          _buildBulletPoint(context, "Biological Filtration",
              "Beneficial bacteria involved in the nitrogen cycle require a stable pH environment to function optimally. Adequate KH ensures these bacteria can efficiently convert ammonia to nitrite and then to nitrate (Hargreaves & Tucker, 2004)."),
          SizedBox(height: 16),
          Text(
            "Effects of Carbonate Hardness on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Carbonate hardness influences several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "Higher KH helps maintain stable pH levels, reducing the risk of sudden changes that can stress aquatic life (Emerson et al., 1975)."),
          _buildBulletPoint(context, "General Hardness (GH)",
              "While KH measures carbonate and bicarbonate ions, GH measures the total concentration of divalent metal ions, primarily calcium and magnesium. Both parameters are important for overall water quality and stability (Boyd, 1990)."),
          _buildBulletPoint(context, "Carbon Dioxide (CO2) Levels",
              "KH interacts with CO2 levels, affecting the pH of the water. Proper KH levels help maintain a balance between CO2 and pH, contributing to overall water stability (Raven & Johnston, 1999)."),
          _buildBulletPoint(context, "Nutrient Availability",
              "KH can influence the availability of nutrients for plants, affecting their growth and health. Proper KH levels ensure that plants can efficiently uptake essential nutrients (Raven et al., 1999)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Carbonate Hardness",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Measuring KH",
              "Carbonate hardness is typically measured in degrees of carbonate hardness (dKH) or parts per million (ppm). Test kits are available to help monitor KH levels in your aquarium (APHA, 1998)."),
          _buildBulletPoint(context, "Adjusting KH",
              "KH can be increased by adding baking soda (sodium bicarbonate) or commercial buffers. To lower KH, use reverse osmosis (RO) water or water softening resins (Boyd, 1990)."),
          _buildBulletPoint(context, "Species-Specific Requirements",
              "Different species have different KH preferences. Research the specific needs of your aquarium inhabitants to ensure they are kept within their optimal KH range (Evans, 2009)."),
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
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
          ),
          _buildReference(
            "Stumm, W., & Morgan, J. J. (1981). Aquatic Chemistry: An Introduction Emphasizing Chemical Equilibria in Natural Waters. John Wiley & Sons.",
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
