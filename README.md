# LaravelCollective HTML to Spatie Laravel HTML Converter

A free toolkit to automate the migration from the abandoned `laravelcollective/html` package to the actively maintained `spatie/laravel-html` package.

## Why Migrate?

LaravelCollective's HTML package has been essentially abandoned, with minimal updates over the years. In contrast, Spatie's Laravel HTML package is:

- Actively maintained and regularly updated
- Compatible with the latest Laravel versions (including Laravel 12)
- Built with a more modern, fluent API
- Better typed and documented

## Installation

1. Clone this repository to your local environment:
```bash
git clone https://github.com/theempiror/spatie_html_convertor.git
cd spatie_html_convertor
```

2. Make all scripts executable:
```bash
chmod +x *.sh
```

## Usage

### Automated Conversion

Run the automated conversion script against your Laravel project directory:

```bash
./autoConversion.sh /path/to/your/laravel/project
```

This will:
1. Scan your project for LaravelCollective HTML syntax
2. Generate a summary of all the HTML components that need conversion
3. Run individual converters for each component type (buttons, checkboxes, emails, etc.)
4. Save a summary file for each conversion type

### Individual Component Conversion

You can also run individual conversion scripts for specific component types:

```bash
./coll2SpatieButton.sh /path/to/your/laravel/project
./coll2SpatieCheckbox.sh /path/to/your/laravel/project
./coll2SpatieEmail.sh /path/to/your/laravel/project
# And so on...
```

## Syntax Migration Guide

### General Pattern

LaravelCollective HTML typically uses static facade calls, while Spatie uses a fluent interface:

#### LaravelCollective:
```php
{!! Form::open(['url' => 'foo/bar']) !!}
    {!! Form::text('name', 'value', ['class' => 'form-control']) !!}
{!! Form::close() !!}
```

#### Spatie:
```php
{{ html()->form('POST', 'foo/bar') }}
    {{ html()->text('name', 'value')->class('form-control') }}
{{ html()->form()->close() }}
```

### Key Component Changes

#### Forms

| LaravelCollective | Spatie |
|------------------|--------|
| `Form::open(['url' => 'foo'])` | `html()->form('POST', 'foo')` |
| `Form::model($user, ['route' => 'users.update'])` | `html()->model($user)->form('PUT', route('users.update'))` |
| `Form::close()` | `html()->form()->close()` |

#### Form Elements

| LaravelCollective | Spatie |
|------------------|--------|
| `Form::text('name', 'value', ['class' => 'form-control'])` | `html()->text('name', 'value')->class('form-control')` |
| `Form::email('email', null, ['placeholder' => 'email@example.com'])` | `html()->email('email')->placeholder('email@example.com')` |
| `Form::password('password', ['class' => 'form-control'])` | `html()->password('password')->class('form-control')` |
| `Form::checkbox('agree', 1, true)` | `html()->checkbox('agree', 1, true)` |
| `Form::radio('size', 'L', true)` | `html()->radio('size', 'L', true)` |
| `Form::select('size', ['L' => 'Large', 'M' => 'Medium'], 'M')` | `html()->select('size', ['L' => 'Large', 'M' => 'Medium'], 'M')` |
| `Form::textarea('description')` | `html()->textarea('description')` |
| `Form::file('photo')` | `html()->file('photo')` |
| `Form::submit('Submit', ['class' => 'btn'])` | `html()->submit('Submit')->class('btn')` |
| `Form::button('Click Me', ['type' => 'button'])` | `html()->button('Click Me', 'button')` |

#### HTML Elements

| LaravelCollective | Spatie |
|------------------|--------|
| `Html::link('url', 'Title')` | `html()->a('url', 'Title')` |
| `Html::image('img.jpg', 'Alt text')` | `html()->img('img.jpg', 'Alt text')` |
| `Html::ul($array)` | `html()->ul()->children($array)` |
| `Html::ol($array)` | `html()->ol()->children($array)` |
| `Html::favicon('favicon.ico')` | `html()->favicon('favicon.ico')` |

## Common Migration Challenges

### Nested Arrays as Attributes
Spatie handles attributes differently. When using nested arrays for attributes, you may need to manually adjust after the automated conversion.

### Custom Form Macros
If you've defined custom macros with LaravelCollective, you'll need to redefine them for the Spatie implementation.

### CSRF Tokens
Spatie automatically includes CSRF tokens in forms, so you don't need to add them manually.

## After Migration Steps

1. Update your composer.json file:
   ```bash
   composer remove laravelcollective/html
   composer require spatie/laravel-html
   ```

2. Update your service provider in `config/app.php`:
   - Remove `Collective\Html\HtmlServiceProvider::class`
   - Add `Spatie\Html\HtmlServiceProvider::class`

3. Update your facades in `config/app.php`:
   - Remove `'Form' => Collective\Html\FormFacade::class`
   - Remove `'Html' => Collective\Html\HtmlFacade::class`
   - Add `'Html' => Spatie\Html\Facades\Html::class` (optional)

4. Run a find/replace in your project to replace remaining Blade directives:
   - Replace `@form_` directives with the equivalent Spatie syntax
   - Replace `@html_` directives with the equivalent Spatie syntax

5. Test thoroughly, especially form submissions and validations.

## Differences to be Aware Of

### Method Naming
Some method names differ between packages. For example, `Html::entities()` becomes `html()->entities()`.

### Fluent Interface
Spatie's package uses a fluent interface for method chaining, which is different from LaravelCollective's approach.

### Attribute Handling
Spatie's approach to HTML attributes is more consistent and offers more flexibility through dedicated trait methods.

## Resources

- [Spatie Laravel HTML Documentation](https://github.com/spatie/laravel-html)
- [LaravelCollective HTML Documentation](https://laravelcollective.com/docs/6.x/html)

## License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
