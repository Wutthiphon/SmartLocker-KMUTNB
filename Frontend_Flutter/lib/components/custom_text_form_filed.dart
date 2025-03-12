import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? inputLabel;
  final String? inputHint;
  final IconData? inputIcon;
  final bool? obscureText;
  final String? Function(String?)? onInputValueChanged;
  final String? Function(String?)? onValidate;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;

  const CustomTextFormField({
    super.key,
    this.inputLabel,
    this.inputHint,
    this.inputIcon,
    this.obscureText,
    this.onInputValueChanged,
    this.onValidate,
    this.autovalidateMode,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Input Label
        inputLabel != null && inputLabel != ''
            ? Column(children: [
                Text(
                  inputLabel ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 41, 38, 99)),
                ),
                const SizedBox(height: 6),
              ])
            : const SizedBox(),
        SizedBox(
          height: 70,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText ?? false,
            scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: inputIcon != null ? 0.0 : 20.0,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color.fromARGB(80, 170, 170, 170),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color.fromARGB(80, 170, 170, 170),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 28, 117, 188),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 255, 87, 34),
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 255, 87, 34),
                  width: 2,
                ),
              ),
              hintText: inputHint,
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 28, 117, 188),
              ),
              errorStyle: const TextStyle(
                height: 0.8,
                color: Color.fromARGB(255, 255, 87, 34),
              ),
              prefixIcon: inputIcon != null && inputIcon != null
                  ? Icon(
                      inputIcon,
                      color: const Color.fromARGB(255, 28, 117, 188),
                    )
                  : null,
            ),
            autovalidateMode: autovalidateMode,
            validator: onValidate,
            onChanged: onInputValueChanged,
          ),
        )
      ],
    );
  }
}
