import "package:analyzer/dart/ast/ast.dart";
import "package:analyzer/dart/ast/token.dart";
import "package:analyzer/error/error.dart" show AnalysisError, ErrorCode;
import "package:analyzer/error/listener.dart";
import "package:analyzer/source/line_info.dart";
import "package:custom_lint_builder/custom_lint_builder.dart";

PluginBase createPlugin() => _TrailingCommaLinter();

class _TrailingCommaLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    _TrailingCommaLintRule(),
  ];
}

class _TrailingCommaLintRule extends DartLintRule {
  const _TrailingCommaLintRule() : super(code: _code);

  static const LintCode _code = LintCode(
    name: "require_trailing_commas_custom",
    problemMessage: "Missing trailing comma",
    correctionMessage: "Try adding a trailing comma.",
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final checker = _TrailingCommaChecker(resolver.lineInfo, reporter, code);

    context.registry
      ..addArgumentList((node) {
        if (node.arguments.isEmpty) return;
        checker.check(
          openingToken: node.leftParenthesis,
          closingToken: node.rightParenthesis,
          firstNode: node.arguments.first,
          lastNode: node.arguments.last,
        );
      })
      ..addAssertInitializer((node) {
        checker.check(
          openingToken: node.leftParenthesis,
          closingToken: node.rightParenthesis,
          firstNode: node.condition,
          lastNode: node.message ?? node.condition,
        );
      })
      ..addAssertStatement((node) {
        checker.check(
          openingToken: node.leftParenthesis,
          closingToken: node.rightParenthesis,
          firstNode: node.condition,
          lastNode: node.message ?? node.condition,
        );
      })
      ..addFormalParameterList((node) {
        if (node.parameters.isEmpty) return;
        checker.check(
          openingToken: node.leftParenthesis,
          closingToken: node.rightParenthesis,
          firstNode: node.parameters.first,
          lastNode: node.parameters.last,
          errorToken: node.rightDelimiter ?? node.rightParenthesis,
        );
      })
      ..addListLiteral((node) {
        if (node.elements.isEmpty) return;
        checker.check(
          openingToken: node.leftBracket,
          closingToken: node.rightBracket,
          firstNode: node.elements.first,
          lastNode: node.elements.last,
        );
      })
      ..addSetOrMapLiteral((node) {
        if (node.elements.isEmpty) return;
        checker.check(
          openingToken: node.leftBracket,
          closingToken: node.rightBracket,
          firstNode: node.elements.first,
          lastNode: node.elements.last,
        );
      })
      ..addRecordLiteral((node) {
        if (node.fields.isEmpty) return;
        checker.check(
          openingToken: node.leftParenthesis,
          closingToken: node.rightParenthesis,
          firstNode: node.fields.first,
          lastNode: node.fields.last,
        );
      })
      ..addRecordPattern((node) {
        if (node.fields.isEmpty) return;
        checker.check(
          openingToken: node.leftParenthesis,
          closingToken: node.rightParenthesis,
          firstNode: node.fields.first,
          lastNode: node.fields.last,
        );
      })
      ..addRecordTypeAnnotation((node) {
        if (node.namedFields == null && node.positionalFields.isEmpty) return;
        final fields = (node.namedFields?.fields ?? node.positionalFields);
        checker.check(
          openingToken: node.leftParenthesis,
          closingToken: node.rightParenthesis,
          firstNode: fields.first,
          lastNode: fields.last,
          errorToken: node.namedFields?.rightBracket ?? node.rightParenthesis,
        );
      })
      ..addSwitchExpression((node) {
        if (node.cases.isEmpty) return;
        checker.check(
          openingToken: node.leftBracket,
          closingToken: node.rightBracket,
          firstNode: node.cases.first,
          lastNode: node.cases.last,
        );
      })
      ..addEnumDeclaration((node) {
        if (node.constants.isEmpty) return;
        checker.check(
          openingToken: node.leftBracket,
          closingToken: node.semicolon ?? node.rightBracket,
          firstNode: node.constants.first,
          lastNode: node.constants.last,
        );
      });
  }

  @override
  List<Fix> getFixes() => [
    _TrailingCommaFix(),
  ];
}

class _TrailingCommaChecker {
  final LineInfo lineInfo;
  final ErrorReporter reporter;
  final ErrorCode code;

  const _TrailingCommaChecker(this.lineInfo, this.reporter, this.code);

  void check({
    required Token openingToken,
    required Token closingToken,
    required AstNode firstNode,
    required AstNode lastNode,
    Token? errorToken,
  }) {
    errorToken ??= closingToken;

    // Early exit if trailing comma is present.
    if (lastNode.endToken.next?.type == TokenType.COMMA) return;

    // If the expression is not intended to be multi-line, ignore it.
    if (!_isMultiline(openingToken, closingToken, firstNode, lastNode)) {
      return;
    }

    reporter.atToken(errorToken, code);
  }

  bool _isSameLine(Token token1, Token token2) =>
      lineInfo.getLocation(token1.offset).lineNumber ==
          lineInfo.getLocation(token2.end).lineNumber;

  /// Returns `true` if the opening and closing tokens are on different lines
  /// than the child nodes.
  bool _isMultiline(
    Token openingToken,
    Token closingToken,
    AstNode firstNode,
    AstNode lastNode,
  ) {
    if (!_isSameLine(openingToken, firstNode.beginToken) &&
        !_isSameLine(closingToken, lastNode.endToken)) {
      return true;
    }
    return false;
  }
}

class _TrailingCommaFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    void createAddTrailingCommaFix(Token previousToken) {
      reporter.createChangeBuilder(
        message: "Add a trailing comma",
        priority: 1,
      ).addDartFileEdit((builder) {
        builder.addSimpleInsertion(previousToken.end, ",");
      });
    }

    context.registry
      ..addArgumentList((node) {
        if (analysisError.offset != node.rightParenthesis.offset) return;
        createAddTrailingCommaFix(node.rightParenthesis.previous!);
      })
      ..addAssertInitializer((node) {
        if (analysisError.offset != node.rightParenthesis.offset) return;
        createAddTrailingCommaFix(node.rightParenthesis.previous!);
      })
      ..addAssertStatement((node) {
        if (analysisError.offset != node.rightParenthesis.offset) return;
        createAddTrailingCommaFix(node.rightParenthesis.previous!);
      })
      ..addFormalParameterList((node) {
        if (analysisError.offset != (node.rightDelimiter ?? node.rightParenthesis).offset) return;
        createAddTrailingCommaFix((node.rightDelimiter ?? node.rightParenthesis).previous!);
      })
      ..addListLiteral((node) {
        if (analysisError.offset != node.rightBracket.offset) return;
        createAddTrailingCommaFix(node.rightBracket.previous!);
      })
      ..addSetOrMapLiteral((node) {
        if (analysisError.offset != node.rightBracket.offset) return;
        createAddTrailingCommaFix(node.rightBracket.previous!);
      })
      ..addRecordLiteral((node) {
        if (analysisError.offset != node.rightParenthesis.offset) return;
        createAddTrailingCommaFix(node.rightParenthesis.previous!);
      })
      ..addRecordPattern((node) {
        if (analysisError.offset != node.rightParenthesis.offset) return;
        createAddTrailingCommaFix(node.rightParenthesis.previous!);
      })
      ..addRecordTypeAnnotation((node) {
        if (analysisError.offset != (node.namedFields?.rightBracket ?? node.rightParenthesis).offset) return;
        createAddTrailingCommaFix(
          (node.namedFields?.rightBracket ?? node.rightParenthesis).previous!,
        );
      })
      ..addSwitchExpression((node) {
        if (analysisError.offset != node.rightBracket.offset) return;
        createAddTrailingCommaFix(node.rightBracket.previous!);
      })
      ..addEnumDeclaration((node) {
        if (analysisError.offset != (node.semicolon ?? node.rightBracket).offset) return;
        createAddTrailingCommaFix((node.semicolon ?? node.rightBracket).previous!);
      })
    ;
  }
}
