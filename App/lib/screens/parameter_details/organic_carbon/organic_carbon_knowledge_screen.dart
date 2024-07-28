import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class OrganicCarbonKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Organic Carbon in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Organic carbon in aquariums consists of a variety of organic compounds derived from plant and animal matter. It plays a significant role in the health and stability of the aquarium ecosystem by influencing the growth of microorganisms and nutrient cycling.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Organic Carbon in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Organic carbon is crucial for the health and stability of aquarium ecosystems. Maintaining appropriate organic carbon levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Microbial Growth",
              "Organic carbon serves as a primary energy source for heterotrophic bacteria, which play a crucial role in decomposing organic matter and recycling nutrients (Wetzel, 2001)."),
          _buildBulletPoint(context, "Nutrient Cycling",
              "The breakdown of organic carbon by bacteria helps recycle essential nutrients such as nitrogen and phosphorus, which are vital for plant and algae growth (Boyd, 1990)."),
          _buildBulletPoint(context, "Water Clarity",
              "Proper management of organic carbon helps maintain water clarity by preventing the buildup of organic debris and promoting the breakdown of organic waste (APHA, 1998)."),
          SizedBox(height: 16),
          Text(
            "Effects of Organic Carbon on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Organic carbon levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Oxygen Levels",
              "High levels of organic carbon can lead to increased bacterial activity, which consumes oxygen and can lead to hypoxic conditions if not properly managed (Wetzel, 2001)."),
          _buildBulletPoint(context, "Ammonia and Nitrite Levels",
              "The decomposition of organic carbon can produce ammonia, which is then converted to nitrite and nitrate through the nitrogen cycle. Proper filtration and water changes help manage these levels (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "pH Levels",
              "The breakdown of organic carbon can produce acids that lower pH levels. Regular monitoring and buffering help maintain stable pH conditions (Stumm & Morgan, 1981)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Organic Carbon",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Sources of Organic Carbon",
              "Organic carbon enters the aquarium through fish waste, uneaten food, decaying plants, and other organic matter. Managing these sources is key to maintaining balance (APHA, 1998)."),
          _buildBulletPoint(context, "Organic Carbon and Filtration",
              "Effective mechanical and biological filtration can help remove and break down excess organic carbon, promoting a healthier aquarium environment (Boyd, 1990)."),
          _buildBulletPoint(context, "Balancing Organic Carbon",
              "Regular water changes, proper feeding practices, and maintaining a balanced fish and plant population help manage organic carbon levels effectively (Wetzel, 2001)."),
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
