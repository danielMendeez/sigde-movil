import 'package:flutter/material.dart';

class FormFooter extends StatelessWidget {
  final String? helpText;
  final FooterLink? primaryLink;
  final String? copyrightText;
  final String? versionText;
  final List<FooterLink>? links;
  final bool showDivider;

  const FormFooter({
    super.key,
    this.helpText,
    this.primaryLink,
    this.copyrightText,
    this.versionText,
    this.links,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDivider) ...[
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300], height: 1),
        ],
        const SizedBox(height: 24),
        if (helpText != null) _buildHelpText(),
        if (primaryLink != null) _buildPrimaryLink(),
        if (links != null && links!.isNotEmpty) _buildLinks(),
        if (copyrightText != null || versionText != null) _buildFooterInfo(),
      ],
    );
  }

  Widget _buildHelpText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        helpText!,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
    );
  }

  Widget _buildPrimaryLink() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: primaryLink!.onTap,
        child: Text(
          primaryLink!.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.green[700],
            fontSize: 15,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLinks() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: links!.map((link) {
          return GestureDetector(
            onTap: link.onTap,
            child: Text(
              link.text,
              style: TextStyle(
                color: Colors.green[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Column(
      children: [
        if (copyrightText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              copyrightText!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        if (versionText != null)
          Text(
            versionText!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400], fontSize: 11),
          ),
      ],
    );
  }
}

class FooterLink {
  final String text;
  final VoidCallback onTap;

  FooterLink({required this.text, required this.onTap});
}
