import "package:flutter/material.dart";

bool isLandscapeMode(BuildContext context) =>
    MediaQuery.sizeOf(context).height < 640;
