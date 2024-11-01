
import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('geography_columns')
export class GeographyColumns {


	@Column({
		type: 'name',

		nullable: true,

	})

	public FTableCatalog: name;



	@Column({
		type: 'name',

		nullable: true,

	})

	public FTableSchema: name;



	@Column({
		type: 'name',

		nullable: true,

	})

	public FTableName: name;



	@Column({
		type: 'name',

		nullable: true,

	})

	public FGeographyColumn: name;



	@Column({
		type: 'integer',

		nullable: true,

	})

	public CoordDimension: number;



	@Column({
		type: 'integer',

		nullable: true,

	})

	public Srid: number;



	@Column({
		type: 'text',

		nullable: true,

	})

	public Type: text;




}

import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('geometry_columns')
export class GeometryColumns {


	@Column({
		type: 'character varying',
		length: 256,
		nullable: true,

	})

	public FTableCatalog: character varying;



	@Column({
		type: 'name',

		nullable: true,

	})

	public FTableSchema: name;



	@Column({
		type: 'name',

		nullable: true,

	})

	public FTableName: name;



	@Column({
		type: 'name',

		nullable: true,

	})

	public FGeometryColumn: name;



	@Column({
		type: 'integer',

		nullable: true,

	})

	public CoordDimension: number;



	@Column({
		type: 'integer',

		nullable: true,

	})

	public Srid: number;



	@Column({
		type: 'character varying',
		length: 30,
		nullable: true,

	})

	public Type: character varying;




}

import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('spatial_ref_sys')
export class SpatialRefSys {


	@PrimaryGeneratedColumn()

	public Srid: number;



	@Column({
		type: 'character varying',
		length: 256,
		nullable: true,

	})

	public AuthName: character varying;



	@Column({
		type: 'integer',

		nullable: true,

	})

	public AuthSrid: number;



	@Column({
		type: 'character varying',
		length: 2048,
		nullable: true,

	})

	public Srtext: character varying;



	@Column({
		type: 'character varying',
		length: 2048,
		nullable: true,

	})

	public Proj4text: character varying;




}

import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('ibge_br_regioes_2022')
export class IbgeBrRegioes2022 {


	@Column({
		type: 'character',
		length: 1,
		nullable: false,
		default: 'nextval(&#39;ibge_br_regioes_2022_cd_reg_seq&#39;::regclass)',
	})

	public CdReg: character;



	@Column({
		type: 'USER-DEFINED',

		nullable: true,

	})

	public Geom: USER-DEFINED;



@Column({
	type: 'character varying',
	length: 20,
	nullable: true,

})

public NmRegiao: character varying;



@Column({
	type: 'character varying',
	length: 2,
	nullable: true,

})

public SiglaRg: character varying;



@Column({
	type: 'double precision',

	nullable: true,

})

public AreaKm2: double precision;




	}

import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('ibge_br_uf_2022')
export class IbgeBrUf2022 {


	@PrimaryGeneratedColumn()

	public CdUf: smallint;



	@Column({
		type: 'USER-DEFINED',

		nullable: true,

	})

	public Geom: USER-DEFINED;



@Column({
	type: 'character varying',
	length: 50,
	nullable: true,

})

public NmUf: character varying;



@Column({
	type: 'character',
	length: 2,
	nullable: true,

})

public SiglaUf: character;



@Column({
	type: 'character varying',
	length: 20,
	nullable: true,

})

public NmRegiao: character varying;



@Column({
	type: 'double precision',

	nullable: true,

})

public AreaKm2: double precision;




	}

import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('iso3166_country')
export class Iso3166Country {


	@PrimaryGeneratedColumn()

	public Code: smallint;



	@Column({
		type: 'character varying',
		length: 255,
		nullable: false,

	})

	public Name: character varying;



	@Column({
		type: 'character',
		length: 2,
		nullable: true,

	})

	public CodeAlpha2: character;



	@Column({
		type: 'character',
		length: 3,
		nullable: true,

	})

	public CodeAlpha3: character;




}

import { Entity, Column, PrimaryGeneratedColumn, OneToOne, JoinColumn } from 'typeorm';

@Entity('isagro_time_series')
export class IsagroTimeSeries {


	@PrimaryGeneratedColumn()

	public Id: number;



	@Column({
		type: 'smallint',

		nullable: false,

	})

	public SeriesId: smallint;



	@Column({
		type: 'smallint',

		nullable: false,

	})

	public CountryId: smallint;



	@Column({
		type: 'integer',

		nullable: false,

	})

	public RegionId: number;



	@Column({
		type: 'date',

		nullable: false,

	})

	public Period: date;



	@Column({
		type: 'character varying',
		length: 50,
		nullable: false,

	})

	public Category: character varying;



	@Column({
		type: 'double precision',

		nullable: false,

	})

	public Value: double precision;



	@Column({
		type: 'timestamp without time zone',

		nullable: true,
		default: 'now()',
	})

	public CreatedAt: timestamp without time zone;



	@Column({
		type: 'timestamp without time zone',

		nullable: true,
		default: 'now()',
	})

	public UpdatedAt: timestamp without time zone;




	@OneToOne(() => iso3166_country, { nullable: true })
	@JoinColumn({ name: 'country_id' })
	public CountryId: iso3166_country;

	@OneToOne(() => isagro_series, { nullable: true })
	@JoinColumn({ name: 'series_id' })
	public SeriesId: isagro_series;

}

import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('isagro_indicator')
export class IsagroIndicator {


	@PrimaryGeneratedColumn()

	public Id: smallint;



	@Column({
		type: 'character varying',
		length: 50,
		nullable: false,

	})

	public Name: character varying;



	@Column({
		type: 'character varying',
		length: 50,
		nullable: false,

	})

	public Slug: character varying;



	@Column({
		type: 'character varying',
		length: 1024,
		nullable: true,

	})

	public Description: character varying;




}

import { Entity, Column, PrimaryGeneratedColumn, OneToOne, JoinColumn } from 'typeorm';

@Entity('isagro_series')
export class IsagroSeries {


	@PrimaryGeneratedColumn()

	public Id: smallint;



	@Column({
		type: 'smallint',

		nullable: false,

	})

	public IndicatorId: smallint;



	@Column({
		type: 'character varying',
		length: 50,
		nullable: false,

	})

	public Name: character varying;



	@Column({
		type: 'character varying',
		length: 50,
		nullable: false,

	})

	public Slug: character varying;



	@Column({
		type: 'character varying',
		length: 1024,
		nullable: true,

	})

	public Description: character varying;



	@Column({
		type: 'character varying',
		length: 4000,
		nullable: true,

	})

	public Source: character varying;




	@OneToOne(() => isagro_indicator, { nullable: true })
	@JoinColumn({ name: 'indicator_id' })
	public IndicatorId: isagro_indicator;

}

import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('tb_item')
export class Item {


	@PrimaryGeneratedColumn()

	public Id: bigint;



	@Column({
		type: 'character varying',
		length: 4000,
		nullable: false,

	})

	public Nome: character varying;



	@Column({
		type: 'character varying',
		length: 12,
		nullable: true,

	})

	public Telefone: character varying;



	@Column({
		type: 'character varying',
		length: 256,
		nullable: false,

	})

	public Senha: character varying;



	@Column({
		type: 'date',

		nullable: false,

	})

	public Nascimento: date;



	@Column({
		type: 'character varying',
		length: 11,
		nullable: false,

	})

	public Cpf: character varying;



	@Column({
		type: 'real',

		nullable: false,

	})

	public Pontuacao: real;



	@Column({
		type: 'boolean',

		nullable: false,
		default: 'true',
	})

	public Ativo: boolean;



	@Column({
		type: 'bytea',

		nullable: true,

	})

	public Avatar: bytea;



	@Column({
		type: 'text',

		nullable: true,

	})

	public Descricao: text;




}

