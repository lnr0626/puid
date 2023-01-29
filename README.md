# Puid

Simple, fast, flexible and efficient generation of probably unique identifiers (`puid`, aka random strings) of intuitively specified entropy using pre-defined or custom characters.

```elixir
  iex> defmodule(RandId, do: use(Puid, chars: :alpha, total: 1.0e5, risk: 1.0e12))
  iex> RandId.generate()
  "YAwrpLRqXGlny"
```

[![Hex Version](https://img.shields.io/hexpm/v/puid.svg "Hex Version")](https://hex.pm/packages/puid) &nbsp; [![License: MIT](https://img.shields.io/npm/l/express.svg)]()

## <a name="TOC"></a>TOC

- [Overview](#Overview)
- [Usage](#Usage)
- [Installation](#Installation)
- [Module API](#ModuleAPI)
- [Chars](#Chars)
- [Comparisons](#Comparisons)
  - [Common Solution](#Common_Solution)
  - [gen_reference](#gen_reference)
  - [misc_random](#misc_random)
  - [nanoid](#nanoid)
  - [Randomizer](#Randomizer)
  - [rand_str](#rand_str)
  - [SecureRandom](#SecureRandom)
  - [ulid](#ulid)
  - [UUID](#UUID)

## <a name="Overview"></a>Overview

A general overview of [PUID](https://github.com/puid/.github/blob/2381099d7f92bda47c35e8b5ae1085119f2a919c/profile/README.md) provides information relevant to all **PUID** implementations.

[TOC](#TOC)

### <a name="Usage"></a>Usage

Creating a random ID generator using `Puid` is a simple as:

```elixir
  iex> defmodule(RandId, do: use(Puid))
  iex> RandId.generate()
  "8nGA2UaIfaawX-Og61go5A"
```

Options allow easy and complete control of ID generation.

**Entropy Source**

`Puid` uses [:crypto.strong_rand_bytes/1](https://www.erlang.org/doc/man/crypto.html#strong_rand_bytes-1) as the default entropy source. The `rand_bytes` option can be used to specify any function of the form `(non_neg_integer) -> binary` as the source:

```elixir
  iex > defmodule(PrngPuid, do: use(Puid, rand_bytes: &:rand.bytes/1))
  iex> PrngPuid.generate()
  "bIkrSeU6Yr8_1WHGvO0H3M"
```

**Characters**

By default, `Puid` use the [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system & URL safe characters. The `chars` option can by used to specify any of 16 [pre-defined character sets](#Chars) or custom characters, including Unicode:

```elixir
  iex> defmodule(HexPuid, do: use(Puid, chars: :hex))
  iex> HexPuid.generate()
  "13fb81e35cb89e5daa5649802ad4bbbd"

  iex> defmodule(DingoskyPuid, do: use(Puid, chars: "dingosky"))
  iex> DingoskyPuid.generate()
  "yiidgidnygkgydkodggysonydodndsnkgksgonisnko"

  iex> defmodule(DingoskyUnicodePuid, do: use(Puid, chars: "dîñgø$kyDÎÑGØßK¥", total: 2.5e6, risk: 1.0e15))
  iex> DingoskyUnicodePuid.generate()
  "øßK$ggKñø$dyGîñdyØøØÎîk"

```

**Captured Entropy**

Generated IDs have 128-bit entropy by default. `Puid` provides a simple, intuitive way to specify ID randomness by declaring a `total` number of possible IDs with a specified `risk` of a repeat in that many IDs:

To generate up to _10 million_ random IDs with _1 in a trillion_ chance of repeat:

```elixir
  iex> defmodule(MyPuid, do: use(Puid, total: 10.0e6, risk: 1.0e15))
  iex> MyPuid.generate()
  "T0bFZadxBYVKs5lA"
```

The `bits` option can be used to directly specify an amount of ID randomness:

```elixir
  iex> defmodule(Token, do: use(Puid, bits: 256, chars: :hex_upper))
  iex> Token.generate()
  "6E908C2A1AA7BF101E7041338D43B87266AFA73734F423B6C3C3A17599F40F2A"
```

[TOC](#TOC)

### <a name="Installation"></a>Installation

Add `puid` to `mix.exs` dependencies:

```elixir
def deps,
  do: [
    {:puid, "~> 2.1"}
  ]
```

Update dependencies

```bash
mix deps.get
```

### <a name="ModuleAPI"></a>Module API

`Puid` modules have two functions:

**`generate/0`**

Generates a **`puid`**
**`info/0`**

Returns a `Puid.Info` structure consisting of

- Source characters
- Name of pre-defined `Puid.Chars` or `:custom`
- Entropy bits per character
- Total entropy bits
  - May be larger than the specified `bits` since it is a multiple of the entropy bits per
    character
- Entropy representation efficiency
  - Ratio of the **`puid`** entropy to the bits required for **`puid`** string representation
- Entropy source function
- **`puid`** string length

### <a name="Chars"></a>Chars

There are 16 pre-defined character sets:

| Name              | Characters                                                                                    |
| :---------------- | :-------------------------------------------------------------------------------------------- |
| :alpha            | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz                                          |
| :alpha_lower      | abcdefghijklmnopqrstuvwxyz                                                                    |
| :alpha_upper      | ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                    |
| :alphanum         | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789                                |
| :alphanum_lower   | abcdefghijklmnopqrstuvwxyz0123456789                                                          |
| :alphanum_upper   | ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789                                                          |
| :base32           | ABCDEFGHIJKLMNOPQRSTUVWXYZ234567                                                              |
| :base32_hex       | 0123456789abcdefghijklmnopqrstuv                                                              |
| :base32_hex_upper | 0123456789ABCDEFGHIJKLMNOPQRSTUV                                                              |
| :decimal          | 0123456789                                                                                    |
| :hex              | 0123456789abcdef                                                                              |
| :hex_upper        | 0123456789ABCDEF                                                                              |
| :safe_ascii       | !#$%&()\*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^\_abcdefghijklmnopqrstuvwxyz{\|}~ |
| :safe32           | 2346789bdfghjmnpqrtBDFGHJLMNPQRT                                                              |
| :safe64           | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-\_                             |
| :symbol           | !#$%&()\*+,-./:;<=>?@[]^\_{\|}~                                                               |

Any `String` or `charlist` of up to 256 unique characters can be used for **`puid`** generation. Custom characters set are optimized in the same manner as the pre-defined character sets.

[TOC](#TOC)


## <a name="Comparisons"></a>Comparisons

As described in the [overview](https://github.com/puid/.github/blob/2381099d7f92bda47c35e8b5ae1085119f2a919c/profile/README.md), **PUID** aims to be a general, flexible mechanism for creating random string for use as random IDs. The following comparisons to other Elixir random ID generators is with respect to the issues of random ID generation described in that overview.

[TOC](#TOC)

### <a name="Common_Solution"></a>[Common Solution](https://gist.github.com/dingosky/86328fc8b51d6b3037087ab1a8d14b4f#file-common_id-ex)

#### Comments

- Entropy source: Generating indexes via a PRNG is straightforward, though wasteful when compared to bit slicing. Generating indexes via a CSPRNG is not straightforward except for hex characters.
- Characters: Full control
- Captured entropy: Indirectly specified via ID length

#### Timing

**PUID** is much faster.

```
Generate 100000 random IDs with 128 bits of entropy using alphanumeric characters

  Common Solution   (PRNG) : 4.977226
  Puid              (PRNG) : 0.831748

  Common Solution (CSPRNG) : 8.435073
  Puid            (CSPRNG) : 0.958437
```

[TOC](#TOC)

### <a name="misc_random"></a>[misc_random](https://github.com/gutschilla/elixir-helper-random)

#### Comments

- Entropy source: No control. Fixed to PRNG `:random.uniform/1`
- Characters: No control. Fixed to `:alphanum`
- Captured entropy: Indirectly specified via ID length

#### Timing

Quite slow compared to **PUID**

```code
Generate 50000 random IDs with 128 bits of entropy using alphanum characters

  Misc.Random (PRNG) : 12.196646
  Puid        (PRNG) : 0.295741

  Misc.Random (CSPRNG) : 11.9858
  Puid        (CSPRNG) : 0.310417
```

[TOC](#TOC)

### <a name="nanoid"></a>[nanoid](https://github.com/railsmechanic/nanoid)

#### Comments:

- Entropy source: Limited control; choice of CSPRNG or PRNG
- Characters: Full control
- Captured entropy: Indirectly specified via ID length

#### Timing:

**nanoid** is much slower than **PUID**

```
  Generate 100000 random IDs with 126 bits of entropy using safe64 characters

    Nanoid (CSPRNG) : 8.480194
    Puid   (CSPRNG) : 0.353484

    Nanoid (PRNG) : 1.603285
    Puid   (PRNG) : 0.425961

  Generate 100000 random IDs with 195 bits of entropy using safe32 characters

    Nanoid (CSPRNG) : 6.117834
    Puid   (CSPRNG) : 0.366509
```

[TOC](#TOC)

### <a name="Randomizer"></a>[Randomizer](https://github.com/jeremytregunna/randomizer)

#### Comments

- Entropy source: No control
- Characters: Limited to five pre-defined character sets
- Captured entropy: Indirectly specified via ID length

#### Timing

Slower than **PUID**

```
Generate 100000 random IDs with 128 bits of entropy using alphanum characters

  Randomizer   (PRNG) : 1.201281
  Puid         (PRNG) : 0.829199

  Randomizer (CSPRNG) : 4.329881
  Puid       (CSPRNG) : 0.807226
```

[TOC](#TOC)

### <a name="SecureRandom"></a>[SecureRandom](https://github.com/patricksrobertson/secure_random.ex)

#### Comments

- Entropy source: No control. Fixed to `:crypto.strong_rand_bytes/1`
- Characters: Limited control for 3 specified use cases
- Captured entropy: Indirectly specified via ID length

#### Timing

About the same as **PUID** when using CSPRNG

```
Generate 500000 random IDs with 128 bits of entropy using hex characters

  SecureRandom (CSPRNG) : 1.19713
  Puid         (CSPRNG) : 1.187726

Generate 500000 random IDs with 128 bits of entropy using safe64 characters

  SecureRandom (CSPRNG) : 2.103798
  Puid         (CSPRNG) : 1.806514
```

[TOC](#TOC)

### <a name="ulid"></a>[ulid](https://github.com/ulid/spec)

#### Comments

Entropy source: No control. Fixed to CSPRNG (per spec)
Characters: No control. Fixed to :base32
Captured entropy: 80-bits per timestamp context

A significant characteristic of **ulid** is the generation of lexicographically sortable IDs. This is not a goal for **PUID**; however, one could use **PUID** to generate such IDs by prefixing a timestamp to a generated **puid**. Such a solution would be similar to **ulid** while still providing full control to **entropy source**, **characters**, and **captured entropy** per timestamp context.

#### Timing

**ulid** and **PUID** are not directly comparable with regard to speed.


[TOC](#TOC)

### <a name="UUID"></a>[UUID](https://github.com/zyro/elixir-uuid)

#### Comments

- Entropy source: No control. Fixed to `crypto.strong_rand_bytes/1`
- Character: No control. Furthermore, string representation is inefficient
- Capture entropy: No control. Fixed to 122 bits

#### Timing

Similar to **PUID** when using CSPRNG

```code
Generate 500000 random IDs with 122 bits of entropy using hex
  UUID     : 1.925131
  Puid hex : 1.823116

Generate 500000 random IDs with 122 bits of entropy using safe64
  UUID        : 1.751625
  Puid safe64 : 1.367201
```

[TOC](#TOC)
