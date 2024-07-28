import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class GeneralHardnessKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of General Hardness in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "General hardness (GH) refers to the concentration of dissolved calcium and magnesium ions in water. It is a crucial parameter in maintaining a healthy aquarium environment, influencing the well-being of fish and plants.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of General Hardness in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "General hardness measures the total concentration of divalent metal ions, mainly calcium (Ca2+) and magnesium (Mg2+). These minerals are vital for various biological processes. Maintaining appropriate GH levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Bone and Scale Formation",
              "Calcium and magnesium are essential for the development and maintenance of bones and scales in fish. Proper GH levels ensure healthy skeletal structures (Boyd, 1990)."),
          _buildBulletPoint(context, "Enzyme Activation",
              "These minerals act as cofactors for many enzymatic reactions, supporting vital metabolic processes in aquatic organisms (Evans, 2009)."),
          _buildBulletPoint(context, "Plant Health",
              "Aquatic plants require calcium and magnesium for cell wall formation and photosynthesis. Adequate GH levels promote robust plant growth (Raven et al., 1999)."),
          SizedBox(height: 16),
          Text(
            "Effects of General Hardness on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "General hardness influences several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "pH Stability",
              "GH can interact with carbonate hardness (KH) to buffer pH levels, contributing to overall pH stability in the aquarium (Boyd, 1990)."),
          _buildBulletPoint(context, "Osmoregulation",
              "Fish maintain osmotic balance with their environment. GH affects the water's osmotic pressure, influencing how fish regulate their internal water and salt concentrations (Evans, 2009)."),
          _buildBulletPoint(context, "Conductivity",
              "GH contributes to the water's conductivity. Higher GH levels increase conductivity, which can be used as an indirect measure of GH (APHA, 1998)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about General Hardness",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Measuring GH",
              "General hardness is typically measured in degrees of hardness (dGH) or parts per million (ppm). Test kits are available to help monitor GH levels in your aquarium (APHA, 1998)."),
          _buildBulletPoint(context, "Adjusting GH",
              "GH can be increased by adding calcium carbonate or magnesium sulfate. To lower GH, use reverse osmosis (RO) water or water softening resins (Boyd, 1990)."),
          _buildBulletPoint(context, "Species-Specific Requirements",
              "Different species have different GH preferences. Research the specific needs of your aquarium inhabitants to ensure they are kept within their optimal GH range (Evans, 2009)."),
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
            "Evans, D. H. (2009). Osmotic and Ionic Regulation: Cells and Animals. CRC Press.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
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
