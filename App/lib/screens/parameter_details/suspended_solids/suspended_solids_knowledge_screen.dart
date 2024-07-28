import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class SuspendedSolidsKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Suspended Solids in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Suspended solids refer to tiny particles that are suspended in the water column of an aquarium. These particles can include uneaten food, fish waste, plant debris, and other organic and inorganic materials. Managing suspended solids is crucial for maintaining water clarity and overall aquarium health.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Suspended Solids in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Suspended solids can impact the aquarium environment in various ways. Maintaining appropriate levels of suspended solids is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Water Clarity",
              "High levels of suspended solids can cloud the water, reducing visibility and light penetration, which is vital for plant photosynthesis and overall aesthetic quality (Boyd, 1990)."),
          _buildBulletPoint(context, "Fish Health",
              "Excessive suspended solids can irritate fish gills, leading to respiratory issues and stress. Keeping solids at a manageable level promotes better health and comfort for fish (Wedemeyer, 1996)."),
          _buildBulletPoint(context, "Filter Efficiency",
              "Suspended solids can clog filters, reducing their efficiency in removing waste and maintaining water quality. Regular maintenance and cleaning of filters are crucial (APHA, 1998)."),
          SizedBox(height: 16),
          Text(
            "Effects of Suspended Solids on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Suspended solids levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Oxygen Levels",
              "High levels of suspended solids can reduce the amount of dissolved oxygen in the water, as decomposing organic matter consumes oxygen. This can lead to hypoxic conditions (Wetzel, 2001)."),
          _buildBulletPoint(context, "Nutrient Cycling",
              "Suspended solids can affect the efficiency of biological filtration processes, impacting the nitrogen cycle and the breakdown of ammonia and nitrites (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "pH Stability",
              "Decomposing organic solids can release acids into the water, potentially affecting pH levels. Proper management helps maintain pH stability (Stumm & Morgan, 1981)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Suspended Solids",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Sources of Suspended Solids",
              "Common sources include uneaten food, fish waste, decaying plants, and dust particles. Regular cleaning and proper feeding practices help manage these sources (APHA, 1998)."),
          _buildBulletPoint(context, "Filtration Methods",
              "Mechanical filtration, such as sponge or particulate filters, effectively removes suspended solids. Combining different types of filtration can improve overall water quality (Boyd, 1990)."),
          _buildBulletPoint(context, "Regular Maintenance",
              "Performing regular water changes, vacuuming the substrate, and cleaning filters are essential practices to keep suspended solids at a manageable level (Wedemeyer, 1996)."),
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
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "Stumm, W., & Morgan, J. J. (1981). Aquatic Chemistry: An Introduction Emphasizing Chemical Equilibria in Natural Waters. John Wiley & Sons.",
          ),
          _buildReference(
            "Wedemeyer, G. (1996). Physiology of Fish in Intensive Culture Systems. Chapman & Hall.",
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
