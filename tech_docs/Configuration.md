# Кастомизация

## Содержание

- [Возможности кастомизации](#Возможности-кастомизации)
- [Параметры конфигурации](#Параметры-конфигурации)
	- [Плейсхолдер](#Placeholder)
	- [Текстовое поле (TextFieldConfiguration)](#TextFieldConfiguration)
	- [Граница текстового поля (TextFieldBorderConfiguration)](#TextFieldBorderConfiguration)
	- [Линия под текстовым полем (LineConfiguration)](#LineConfiguration)
	- [Подсказка (HintConfiguration)](#HintConfiguration)
	- [Режим ввода пароля (PasswordModeConfiguration)](#PasswordModeConfiguration)
	- [Кнопка очистки (ActionButtonConfiguration)](#ActionButtonConfiguration)
	- [Background (BackgroundConfiguration)](#BackgroundConfiguration)
	- [Настройка цвета (ColorConfiguration)](#ColorConfiguration)
- [Создание собственного поля ввода](#Создание-собственного-поля-ввода)

## Возможности кастомизации

Основная цель, преследовавшаяся при создании существующей системы кастомизации полей - сделать изменяемым все то, что в коде изначально задавалось константами: шрифт, его кегль, любой цвет, размеры элементов и их расположение. Часть из этих параметров вы можете кастомизировать, создав наследника поля со своим `.xib` файлом, где расположение и размер некоторых элементов будет отвечать вашим требованиям (подробнее этот процесс описан [ниже](#Создание-собственного-поля-ввода) в данной статье). Остальная же часть параметров задается через параметр `configuration`, существующий у каждого поля ввода данной библиотеки.

Каждое поле ввода имеет свой класс объекта `configuration`: `BorderedTextFieldConfiguration`, `UnderlinedTextFieldConfiguration`, `UnderlinedTextViewConfiguration`. Такая реализация необходима в силу того, что каждое поле уникально в своем роде, и требует различные параметры конфигурации для своей работы.

Рассмотрим более подробно элементы, доступные для изменения:

* UnderlinedTextField
	* [Плейсхолдер](#Placeholder)
	* [Текстовое поле](#TextFieldConfiguration)
	* [Линия под текстовым полем](#LineConfiguration)
	* [Подсказка](#HintConfiguration)
	* [Режим ввода пароля](#PasswordModeConfiguration)
	* [Background](#BackgroundConfiguration)
* UnderlinedTextView
	* [Плейсхолдер](#Placeholder)
	* [Текстовое поле](#TextFieldConfiguration)
	* [Линия под текстовым полем](#LineConfiguration)
	* [Подсказка](#Подсказка-(HintConfiguration))
	* [Кнопка очистки](#ActionButtonConfiguration)
	* [Background](#BackgroundConfiguration)

## Параметры конфигурации

### Placeholder

В последних версиях библиотеки - возможности плейсхолдеров были расширены. Теперь вы не ограничены в их выборе, реализации или количестве. Все что нужно для того, чтобы добавить к полю плейсхолдер - это передать ему сервис, который бы удовлетворял протоколу `AbstractPlaceholderService` (сервис будет отвечать полностью за отрисовку и поведение плейсхолдера) и передать его в методы поля ввода на выбор:

````swift
func setup(placeholderServices: [AbstractPlaceholderService])		// если вы конфигурируете начальное состояние поля ввода
func add(placeholderService service: AbstractPlaceholderService)	// ели вы хотите добавить доп плейсхолдер к существующему
````

На выбор предоставляется несколько готовых сервисов для реализации плейсхолдеров:

* `FloatingPlaceholderService` - *плавающее* поведение плейхолдера
* `StaticPlaceholderService` - плейсхолдер находится на одном месте, не меняя свое положение, цвет текста или кегль шрифта
* `NativePlaceholderService` - плейсхолдер имитирует поведение стандартного системного плейсхолдера

Каждый из предопределенных типов плейсхолдера требует в качестве параметра передать объект с конфигурацией, на основе которого будет определяться логика работы плейсхолдера и его внешний вид.

Плейсхолдер типа `floating` представляет собой CATextLayer, который изменяет свое положение, цвет и кегль шрифта в зависимости от состояния поля ввода. Требует предоставления объекта класса `FloatingPlaceholderConfiguration`, в котором возможна указание, а следственно и кастомизация, следующих значений:

* `font: UIFont` - шрифт текста для плейсхолдера. В данном случае, значимым является только `fontName`, кегль шрифта задается в других параметрах
* `height: CGFloat` - высота плейсхолдера
* `topInsets: UIEdgeInsets` - отступы плейсхолдера от границ контейнера, когда он находится в верхнем положении. Итоговое положение рассчитывается относительно верхней границы контейнера, потому параметр `bottom` будет игнорироваться
* `bottomInsets: UIEdgeInsets` - отступы плейсхолдера от границ контейнера, когда он находится в нижнем положении. Итоговое положение рассчитывается относительно верхней границы контейнера, потому параметр `bottom` будет игнорироваться
* `increasedRightPadding: CGFloat` - при добавление кнопки к полю ввода (к примеру, в режиме ввода пароля) плейсхолдер может "заехать" на нее. Чтобы этого не случилось - можно использовать этот параметр, который фактически означает "отступ плейсхолдера от правой границы контейнера, когда в поле ввода присутствует actionButton". Аналогичные значения из topInsets/bottomInsets будут в этом случае игнорироваться. (Примечание: актуально только для UnderlinedTextField, в textView это значение игнорируется)
* `smallFontSize: CGFloat` - кегль шрифта для плейсхолдера, когда он будет находиться вверху
* `bigFontSize: CGFloat` - кегль шрифта для плейсхолдера, когда он будет находиться внизу
* `topColors: ColorConfiguration` - настройка цвета плейсхолдера в состоянии, когда он вверху ([ColorConfiguration](#ColorConfiguration))
* `bottomColors: ColorConfiguration` - настройка цвета плейсхолдера в состоянии, когда он внизу ([ColorConfiguration](#ColorConfiguration))

Плейсхолдер типа `static` - просто статический UILabel(), в котором вы можете указать свой текст. Требует для своей работы объект класса `StaticPlaceholderConfiguration`:

* `font: UIFont` - шрифт плейсхолдера
* `topInsets: UIEdgeInsets` - отступы плейсхолдера от границ контейнера. Итоговое положение рассчитывается относительно верхней границы контейнера, потому параметр `bottom` будет игнорироваться
* `height: CGFloat` - высота плейсхолдера
* `colors: ColorConfiguration` - настройка цвета плейсхолдера в разных состояниях (смотри [ColorConfiguration](#ColorConfiguration))

Плейсхолдер типа `native` - самый сложный в понимании и кастомизации элемент, несмотря на свое "простое" название.

Предположим, вам необходимо установить два плейхолдера - основной и вспомогательный. Вспомогательный может использоваться для различного рода уточнений во время ввода сложных данных, для улучшения UX, к примеру:

* в качестве главного плейсхолдера устанавливаем `floating` плейсхолдер для поля ввода номера карты. Когда нажимаем на поле ввода - floating плейсхолдер уезжает вверх, а на его месте появляется подсказка вида "XXXX-XXXX", которая как бы подсказывает пользователю, что ему надо будет ввести 8 цифр, а формат маски-подсказки поможет ему найти и распознать этот номер на своей физической карте
* для указания такой подсказки вида "ХХХХ-ХХХХ" - как раз таки и предназначен вспомогательный плейсхолдер

Таким образом, плейсхолдер с типом `native` может быть использован в равной степени как для реализации главного плейсхолдера (в таком случае он просто имитирует поведение нативного плейсхолдера), так и в качестве вспомогательного. Требует для своей работы объект класса `NativePlaceholderConfiguration`, который является наследником от `StaticPlaceholderConfiguration` и дополнительно содержит следующие поля:

* `behavior: NativePlaceholderBehavior` - данный параметр поможет выбрать поведение плейсхолдера из двух доступных: при указании параметра `.hideOnFocus` - плейсхолдер будет скрываться при фокусе в поле (как и настоящий нативный плейсхолдер), при указании `.hideOnInput` - только если в поле ввода есть хотя бы один символ
* `useAsMainPlaceholder: Bool` - при указании `true` поведение плейсхолдера будет изменено таким образом, как будто он отображается как "главный" плейсхолдер, при указании "false" - как будто это вспомогательный плейсхолдер. Фактически, на уровне внутренней логики: в случае, если это вспомогательный плейсхолдер - он будет показан только при отсутствии текста в активном состоянии поля ввода
* `increasedRightPadding: CGFloat` - как и во `FloatingPlaceholderConfiguration` - это отступ справа для плейсхолдера, если в поле ввода присутствует кнопка

При конфигурировании плейсхолдера такого типа - будьте аккуратны, так как некоторые совокупности параметров не несут никакого смысла (к примеру, если использовать его как support с поведением `.hideOnFocus` - в таком кейсе плейсхолдер никогда в жизни не покажется).

Если вам не хватает того функционала, который покрывают вышеперечисленные сервисы - вы можете написать свой собственный и использовать его :) В качестве примера - можно обратиться к Example проекту и найти там `CurrencyPlaceholderService`.

### TextFieldConfiguration

Параметры настройки текста и его отступов в поле ввода.

* `font: UIFont` - шрифт текста в поле ввода
* `defaultPadding: UIEdgeInsets` - отступы для текста в обычном состоянии, без каких-либо кнопок
* `increasedPadding: UIEdgeInsets` - данные отступы для текста в поле ввода будут применены при наличии `action` кнопки, к примеру, в режиме ввода пароля
* `tintColor: UIColor` - `tintColor` для поля ввода (фактически, цвет курсора)
* `colors: ColorConfiguration` - настройка цвета текста в различных состояниях поля ввода ([ColorConfiguration](#ColorConfiguration))

### TextFieldBorderConfiguration

Параметры для настройки границы таблицы, используется в данный момент только в поле `BorderedTextField`.

* `cornerRadius: CGFloat` - радиус скругления границы
* `width: CGFloat` - ширина границы
* `colors: ColorConfiguration` - цвета границы в различных состояниях поля ввода ([ColorConfiguration](#ColorConfiguration))

### LineConfiguration

Параметры для настройки цвета, размера и положения линии под полем ввода.

* `insets: UIEdgeInsets` - параметр позволяет управлять положением линии, отступы рассчитываются относительно верха контейнера, параметр `.bottom` будет в силу этого проигнорирован. При установке в `.zero` - линия не будет отрисована.
* `defaultHeight: CGFloat` - высота линии в неактивном состоянии поля ввода
* `increasedHeight: CGFloat` - высота линии, когда поле ввода в фокусе
* `cornerRadius: CGFloat` - радиус скругления линии
* `colors: ColorConfiguration` - цвета линии в различных состояниях поля ввода ([ColorConfiguration](#ColorConfiguration))

### HintConfiguration

Параметры конфигурации для лейбла сподсказкой/сообщением об ошибке.

* `font: UIFont` - шрифт для текста в лейбле с подсказкой
* `lineHeight: CGFloat` - под капотом в лейбле будет показана `attributedString` с нестандартным межстрочным интервалом, данным параметром можно управлять этим интервалом. Соответствует параметру `lineHeight` в Figma.
* `colors: ColorConfiguration` - цвет текста в лейбле в зависимости от состояния поля ввода ([ColorConfiguration](#ColorConfiguration))

### PasswordModeConfiguration

Параметры для настройки режима ввода пароля, позволяет определить цвета и иконки для кнопки, переключающей `isSecureTextEntry` значение.

* `secureModeOnImage: UIImage` - иконка кнопки, которая будет показана в режиме secure ввода
* `secureModeOffImage: UIImage` - иконка кнопки, которая будет показана при отключенном режиме secure ввода
* `normalColor: UIColor` - цвет иконки в нормальном состоянии
* `pressedColor: UIColor` - цвет иконки в нажатом состоянии

### ActionButtonConfiguration

У некоторых полей ввода присутствует возможность показа некой своей кастомной кнопки. С помощью данных параметров можно настроить ее визуальное отображение.

* `image: UIImage` - иконка в кнопке
* `normalColor: UIColor` - цвет иконки в нормальном состоянии
* `pressedColor: UIColor` - цвет иконки в нажатом состоянии

### BackgroundConfiguration

Данный параметр позволяет переопределить цвет backgroundColor для контейнера с полем ввода.

* `color: UIColor` - backgroundColor контейнера с полем ввода

### ColorConfiguration

Данные параметры позволяют переопределить цвет различных элементов внутри полей ввода.

* `error: UIColor` - цвет элемента в состоянии ошибки
* `normal: UIColor` - цвет элемента в нормальном состоянии (поле ввода не в фокусе)
* `active: UIColor` - цвет элемента в активном состоянии (когда поле ввода в фокусе)
* `disabled: UIColor` - цвет элемента в задизейбленном состоянии

## Создание собственного поля ввода

Зачастую при реализации того или иного поля ввода необходимо строго соблюсти дизайн: требуется точная установка положения и размеров тех или иных элементов. В этом случае - вам необходимо всего лишь создать собственный наследник от уже существующего поля ввода и с собственным `.xib` файлом.

**Важно**: при верстке вы можете поменять положение элементов, сделав свое поле уникальным, не похожим на другое, но при этом требуется выполнение одного единственного правила: все `IBOutlet` должны быть установлены. Если вам, к примеру, не нужен подстрочеченик с текстом ошибки/подсказки - вы можете поставить ему в качестве цвета текста `UIColor.clear`, или сделать его фрейм таким, что он никогда не будет отображен в поле ввода, но `IBOutlet` к нему необходимо притянуть в любом случае.

Предположим, что нам нужно создать свое поле `MyTextField`, дизайн которого в целом похож на `UnderlinedTextField`. Необходимо выполнить следующие шаги:

* создать два файла `MyTextField.swift`, `MyTextField.xib`
* в файле `MyTextField.swift` определить класс `final class MyTextField: UnderlinedTextField`
* в `.xib` файле указать в качестве File's Owner класс `MyTextField`
* перенести на view объект UITextField, и **внимание**: задать ему класс `InnerTextField`, ведь под капотом используется именно он. В качестве `Module` должен автоматически подставиться модуль TextFieldsCatalog
* то же самое и с кнопкой: она является наследником от `IconButton` из модуля TextFieldsCatalog
* добавить лейбл для подсказки
* подсоединить все IBOutlet-ы
* в классе `MyTextField` на создании объекта добавить код, переопределяющий его конфигурацию

В качестве примера можно посмотреть поле `CustomUnderlinedTextField` из Example-проекта.