import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../utils/app_color.dart';

Widget myText({text, style, textAlign, maxLines}) {
  return Text(
    text,
    style: style,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLines,
    softWrap: false,
  );
}

Widget textField(
    {text,
    TextEditingController? controller,
    Function? validator,
    int? maxLength,
    TextInputType inputType = TextInputType.text}) {
  return Container(
    margin: EdgeInsets.only(bottom: Get.height * 0.02),
    child: TextFormField(
      keyboardType: inputType,
      maxLength: maxLength,
      controller: controller,
      validator: (input) => validator!(input),
      decoration: InputDecoration(
          hintText: text,
          errorStyle: const TextStyle(fontSize: 0),
          contentPadding: const EdgeInsets.only(top: 10, left: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
    ),
  );
}

Widget textFormFieldForController(
    {hintText,
    String? icon,
    obscure = false,
    readOnly = false,
    int? maxLength,
    String? labelText,
    inputType = TextInputType.text,
    TextEditingController? controller,
    Function? validator}) {
  return SizedBox(
    child: TextFormField(
      validator: (input) => validator!(input),
      obscureText: obscure,
      readOnly: readOnly,
      maxLength: maxLength,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 5),
          errorStyle: const TextStyle(fontSize: 0),
          hintStyle: TextStyle(
            color: AppColors.genderTextColor,
          ),
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Image.asset(
            icon!,
            cacheHeight: 20,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
    ),
  );
}

Widget textFormFieldForValue({
  hintText,
  String? icon,
  obscure = false,
  readOnly = false,
  String? initialValue,
  int? maxLength,
  String? labelText,
  Function? validator,
  TextInputType inputType = TextInputType.text,
  Function? onChanged,
}) {
  return SizedBox(
    child: TextFormField(
      maxLength: maxLength,
      keyboardType: inputType,
      onChanged: (input) => onChanged!(input),
      initialValue: initialValue,
      validator: (input) => validator!(input),
      obscureText: obscure,
      readOnly: readOnly,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 5),
          errorStyle: const TextStyle(fontSize: 0),
          hintStyle: TextStyle(
            color: AppColors.genderTextColor,
          ),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Image.asset(
            icon!,
            cacheHeight: 20,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
    ),
  );
}

Widget socialAppsIcons({text, Function? onPressed}) {
  return InkWell(
    onTap: () => onPressed!(),
    child: Container(
      margin: const EdgeInsets.all(10),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(text),
        ),
      ),
    ),
  );
}

Widget settingIconAndText(
  Function onPressed, {
  text,
  image,
}) {
  return ListTile(
    onTap: () => onPressed(),
    leading: SvgPicture.asset(
      image,
      height: 20,
    ),
    title: Transform.translate(
      offset: const Offset(-16, 0),
      child: Text(text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
    ),
  );
}

Widget elevatedButton({text, Function? onPress}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.blue),
    ),
    onPressed: () {
      onPress!();
    },
    child: Text(
      text,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget labelTextField({label, hintText}) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    height: 48,
    child: TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: label,
        hintText: hintText,
      ),
    ),
  );
}

Widget rowContainer(Function onPressed, {text}) {
  return InkWell(
    onTap: () => onPressed(),
    child: Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.5, color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          myText(
              text: text,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          )
        ],
      ),
    ),
  );
}

Widget iconWithTitle({text, Function? func, bool? isShow = true}) {
  return Row(
    children: [
      !isShow!
          ? Container()
          : Expanded(
              flex: 0,
              child: InkWell(
                onTap: () {
                  func!();
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: Get.width * 0.02,
                    top: Get.height * 0.08,
                    bottom: Get.height * 0.02,
                  ),
                  // alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    // border: Border.all(width: 1),
                    // borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image: AssetImage('assets/Header.png'),
                    ),
                  ),
                ),
              ),
            ),
      Expanded(
        flex: 6,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: Get.height * 0.056,
            // left: Get.width * 0.26,
          ),
          child: myText(
            text: text,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      const Expanded(
        flex: 1,
        child: Text(''),
      )
    ],
  );
}

Widget iconTitleContainer(
    {text,
    path,
    Function? onPress,
    bool isReadOnly = false,
    TextInputType type = TextInputType.text,
    TextEditingController? controller,
    Function? validator,
    double width = 150,
    double height = 40}) {
  return Container(
    // padding: EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(width: 0.1, color: AppColors.genderTextColor),
    ),
    width: width,
    height: height,
    child: TextFormField(
      validator: (String? input) => validator!(input!),
      controller: controller,
      keyboardType: type,
      readOnly: isReadOnly,
      onTap: () => onPress!(),
      // style: TextStyle(
      //   fontSize: 16,
      //   fontWeight: FontWeight.w400,
      //   color: AppColors.genderTextColor,
      // ),
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 0),
        contentPadding: const EdgeInsets.only(top: 3),
        prefixIcon: Image.asset(
          path,
          cacheHeight: 18,
        ),
        hintText: text,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.genderTextColor,
        ),
        border: isReadOnly
            ? OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffA6A6A6)),
                borderRadius: BorderRadius.circular(8))
            : OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}

Widget userProfile({title, path, style}) {
  return Row(
    children: [
      path.toString().isEmpty
          ? Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
              child: Icon(
                Icons.person,
                color: AppColors.white,
              ),
            )
          : Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(path), fit: BoxFit.fill)),
            ),
      const SizedBox(
        width: 10,
      ),
      myText(text: title, style: style)
    ],
  );
}
/*Widget completeCommunityWidget({
  imagePath,
  imageTitle,
  imagePath1,
  imageTitle1,
  centerImage,
  lastTitle,
  imagePath2,
  imageTitle2,
}) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                community1st(
                  path: imagePath,
                  title: imageTitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff333333),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.asset(imagePath1),
                    SizedBox(
                      width: 10,
                    ),
                    myText(
                      text: imageTitle1,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff303030),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    centerImage,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                community1st(
                  path: imagePath2,
                  title: imageTitle2,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff939394),
                  ),
                ),
                myText(
                    text: lastTitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ))
              ],
            ),
          ),
        ],
      ),
      Divider()
    ],
  );
}
?
 */
/*Widget community1st({title, path, style}) {
  return Row(
    children: [
      path.toString().isEmpty
          ? Container(
              width: 24,
              height: 24,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Icon(
                Icons.person,
                color: AppColors.white,
              ),
            )
          : Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(path), fit: BoxFit.fill)),
            ),
      SizedBox(
        width: 10,
      ),
      myText(text: title, style: style)
    ],
  );
}*/
